{ upstream }:

upstream.overrideAttrs (old: {
  # Keep upstream installation and its Python wrapper; load only our socket-driven plugin.
  postPatch = (old.postPatch or "") + ''
    rm -f led_mon/plugins/*_plugin.py
    cp ${./omp_context_plugin.py} led_mon/plugins/omp_context_plugin.py
  '';
})
