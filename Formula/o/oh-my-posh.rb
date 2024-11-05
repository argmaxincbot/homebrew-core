class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.6.tar.gz"
  sha256 "9103b79366ca7596ee8782f49f02939bd5aead1caba080e1d9ad0b18e556eb38"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c16554ea9f69c500c890c315bb33819492fd9536b7f274c2156e8c33ec994a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a9e0fd9bec15262f592f8937da2c02bf0b177208f9e4f616742def3a9e07e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8abf6be1d83a9f62d7e1827e5283a7fb2343686bbbe1c14280f52ea0ec5d32a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbb1db83b8880b9307e91e60a8bfb754c7f6536fb432cf6eda8d3c3c22de709f"
    sha256 cellar: :any_skip_relocation, ventura:       "c1d6beb612374b6dff0e9f3dc9e1287549e3748165c9265a2f9398357d54195e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d621bd412c109f5595daac926e990c27df5ae2355a1748667622a7976f3e6a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
