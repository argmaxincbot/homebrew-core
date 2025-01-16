class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.259.0.tar.gz"
  sha256 "bed9a4cd4a7142c9c9821f948e6df45c0abfcc0c01dfabc1822b485828afeba8"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a59fa6b9aa95f512fe00561a2d0df87f191f7069fe72f3043667b5c9d01367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7b240ff9ea8659f98563518bd81fec750a45f0518ff253f1a1bd709d85fd61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "670bbf3642446112d92fc67217265916f24c82e5512d9daa00e427e18042de99"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd711dc0f352390a0b2ac4a4154a01cfc7de549df56a6431b4976656431c81fc"
    sha256 cellar: :any_skip_relocation, ventura:       "da963658206f3a4d14ee756294db8b53f5bcf78d85712e36e6b0ac8525d61488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95452629703eb601c56800e952dc5bdbc4f24209bb45c40638524ca46662136e"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
