{
  pkgs,
  lib,
  config,
  ...
}:
let
  timewHookPy = pkgs.writeText "on-modify.timewarrior.py" ''
    import json
    import subprocess
    import sys

    try:
        input_stream = sys.stdin.buffer
    except AttributeError:
        input_stream = sys.stdin


    def billing_tags(task):
        tags = []
        if "project" in task:
            parts = task["project"].split(".")
            tags += [".".join(parts[:i]) for i in range(1, len(parts) + 1)]
        tags.append(task.get("linearidentifier") or task["description"])
        return tags


    def main(old, new):
        started = "start" in new and "start" not in old
        stopped = "start" in old and ("start" not in new or "end" in new)
        running = "start" in old and "start" in new

        if started:
            subprocess.call(["timew", "start"] + billing_tags(new) + [":yes"])
            subprocess.call(["timew", "annotate", "@1", new["description"]])
        elif stopped:
            subprocess.call(["timew", "stop", ":yes"])
        elif running:
            if billing_tags(old) != billing_tags(new):
                subprocess.call(["timew", "untag", "@1"] + billing_tags(old) + [":yes"])
                subprocess.call(["timew", "tag", "@1"] + billing_tags(new) + [":yes"])
            if old["description"] != new["description"]:
                subprocess.call(["timew", "annotate", "@1", new["description"]])


    if __name__ == "__main__":
        old = json.loads(input_stream.readline().decode("utf-8", errors="replace"))
        new = json.loads(input_stream.readline().decode("utf-8", errors="replace"))
        print(json.dumps(new))
        main(old, new)
  '';

  # Wrapper: stock hook assumes `python3`/`timew` on PATH; neither resolves in
  # taskwarrior's hook env on NixOS, so set them explicitly.
  timewarriorHook = pkgs.writeShellScript "on-modify.timewarrior" ''
    export PATH=${lib.makeBinPath [ pkgs.timewarrior ]}:$PATH
    exec ${pkgs.python3}/bin/python3 ${timewHookPy} "$@"
  '';

  # Mark in-progress on `task start` (durable through `stop`, cleared on `done`),
  # so paused work stays visible in `wip` — `+ACTIVE` only marks a running timer.
  # Runs before the timew hook (alphabetical), so the tag reaches timewarrior too.
  inprogressHook = pkgs.writeScript "on-modify.inprogress" ''
    #!${pkgs.python3}/bin/python3
    import sys, json

    original = json.loads(sys.stdin.readline())
    modified = json.loads(sys.stdin.readline())
    tags = modified.get("tags", [])

    if "start" in modified and "start" not in original and "inprogress" not in tags:
        tags.append("inprogress")
    if modified.get("status") == "completed" and "inprogress" in tags:
        tags.remove("inprogress")

    if tags:
        modified["tags"] = tags
    elif "tags" in modified:
        del modified["tags"]

    print(json.dumps(modified))
  '';
in
{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    config = {
      hooks.location = "${config.xdg.configHome}/task/hooks";

      urgency.tags.coefficient = 0;
      urgency."inherit" = 1;
      urgency.blocking.coefficient = 0;
      urgency.blocked.coefficient = 0;
      urgency.due.coefficient = 4;
      urgency.project.coefficient = 0;
      urgency.user.tag.inprogress.coefficient = 2.5;

      context.work.read = "project:bidpoint";
      context.personal.read = "project.not:bidpoint";

      uda = {
        # No default: an unset value flags a task as not-yet-enriched.
        brainpower = {
          type = "string";
          label = "Brainpower";
          values = "H,M,L";
        };
        est = {
          type = "duration";
          label = "Estimate";
        };

        # Declared so reports can filter on them; bugwarrior writes them regardless.
        linearurl.type = "string";
        linearurl.label = "Issue URL";
        lineartitle.type = "string";
        lineartitle.label = "Issue Title";
        lineardescription.type = "string";
        lineardescription.label = "Issue Description";
        linearstatus.type = "string";
        linearstatus.label = "Issue State";
        linearidentifier.type = "string";
        linearidentifier.label = "Linear Identifier";
        linearteam.type = "string";
        linearteam.label = "Team";
        linearcreator.type = "string";
        linearcreator.label = "Issue Creator";
        linearassignee.type = "string";
        linearassignee.label = "Issue Assignee";
        linearcreated.type = "date";
        linearcreated.label = "Issue Created";
        linearupdated.type = "date";
        linearupdated.label = "Issue Updated";
        linearclosed.type = "date";
        linearclosed.label = "Issue Closed";
      };

      report = {
        "in" = {
          description = "Inbox to process";
          columns = [
            "id"
            "linearidentifier"
            "entry.age"
            "project"
            "description"
          ];
          labels = [
            "ID"
            "Linear"
            "Age"
            "Proj"
            "Description"
          ];
          filter = "status:pending +in";
          sort = "entry+";
        };

        next = {
          description = "Actionable next actions";
          columns = [
            "id"
            "project"
            "priority"
            "brainpower"
            "est"
            "urgency"
            "due"
            "description"
            "tags"
          ];
          labels = [
            "ID"
            "Proj"
            "Pri"
            "Brain"
            "Est"
            "Urg"
            "Due"
            "Description"
            "Tags"
          ];
          filter = "status:pending -WAITING -BLOCKED -sdm -in linearstatus.isnt:Done +READY";
          sort = "urgency-";
        };

        today = {
          description = "Committed set for today";
          columns = [
            "id"
            "project"
            "priority"
            "brainpower"
            "est"
            "urgency"
            "due"
            "description"
          ];
          labels = [
            "ID"
            "Proj"
            "Pri"
            "Brain"
            "Est"
            "Urg"
            "Due"
            "Description"
          ];
          filter = "status:pending +today -WAITING -BLOCKED linearstatus.isnt:Done";
          sort = "urgency-";
        };

        wip = {
          description = "In progress (running or paused)";
          columns = [
            "id"
            "project"
            "start.active"
            "brainpower"
            "est"
            "description"
            "tags"
          ];
          labels = [
            "ID"
            "Proj"
            "A"
            "Brain"
            "Est"
            "Description"
            "Tags"
          ];
          filter = "status:pending -BLOCKED and ( +inprogress or +ACTIVE )";
          sort = "urgency-";
        };

        weekly = {
          columns = [
            "id"
            "start"
            "end"
            "description"
            "project"
            "tags"
          ];
          labels = [
            "ID"
            "Started"
            "Ended"
            "Description"
            "Project"
            "Tags"
          ];
          sort = "start+";
          filter = "status:completed and end.after:now-7d";
          description = "Completed tasks in the last 7 days";
        };
      };
    };
  };

  xdg.configFile = {
    "task/hooks/on-modify.timewarrior" = {
      source = timewarriorHook;
      executable = true;
    };
    "task/hooks/on-modify.inprogress" = {
      source = inprogressHook;
      executable = true;
    };
  };

  systemd.user.services.taskwarrior-today-reset = {
    Unit.Description = "Strip the +today commitment set for a blank-slate morning";
    Service = {
      Type = "oneshot";
      Environment = "TASKRC=%h/.config/task/taskrc";
      ExecStart = "${pkgs.writeShellScript "taskwarrior-today-reset" ''
        ${pkgs.taskwarrior3}/bin/task rc.confirmation=off status:pending +today modify -today || true
      ''}";
    };
  };

  systemd.user.timers.taskwarrior-today-reset = {
    Unit.Description = "Nightly +today reset";
    Timer = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  home.packages = [
    pkgs.timewarrior
    pkgs.taskwarrior-tui
    pkgs.taskopen
  ];

  # carapace's `task` completer is go-task, not taskwarrior; excluding it lets
  # taskwarrior's native `_task` completion (shipped on fpath) take over.
  home.sessionVariables.CARAPACE_EXCLUDES = "task";
}
