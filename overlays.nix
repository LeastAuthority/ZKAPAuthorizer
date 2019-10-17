self: super: {
  ristretto = super.callPackage ./ristretto.nix { };

  python27 = super.python27.override {
    packageOverrides = python-self: python-super: {
      # The newest typing is incompatible with the packaged version of
      # Hypothesis.  Upgrading Hypothesis is like pulling on a loose thread in
      # a sweater.  I pulled it as far as pytest where I found there was no
      # upgrade route because pytest has dropped Python 2 support.
      # Fortunately, downgrading typing ends up being fairly straightforward.
      #
      # For now.  This is, no doubt, a sign of things to come for the Python 2
      # ecosystem - the early stages of a slow, painful death by the thousand
      # cuts of incompatibilities between libraries with no maintained Python
      # 2 support.
      typing = python-super.callPackage ./typing.nix { };

      # new tahoe-lafs dependency
      eliot = python-super.callPackage ./eliot.nix { };
      # new autobahn requires a newer cryptography
      cryptography = python-super.callPackage ./cryptography.nix { };
      # new cryptography requires a newer cryptography_vectors
      cryptography_vectors = python-super.callPackage ./cryptography_vectors.nix { };
      # new tahoe-lafs depends on a very recent autobahn for better
      # websocket testing features.
      autobahn = python-super.callPackage ./autobahn.nix { };

      # tahoe-lafs in nixpkgs is packaged as an application!  so we have to
      # re-package it ourselves as a library.
      tahoe-lafs = python-super.callPackage ./tahoe-lafs.nix { };

      # we depend on the privacypass python library, a set of bindings to the
      # challenge-bypass-ristretto Rust library
      privacypass = python-super.callPackage ./privacypass.nix { };

      # And add ourselves to the collection too.
      zkapauthorizer = python-super.callPackage ./zkapauthorizer.nix { };
    };
  };
}
