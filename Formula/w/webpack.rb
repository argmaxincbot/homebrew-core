require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.96.0.tgz"
  sha256 "86246bac897bdf4ae60986b973575d5b01e6071bddd2f4f1c1d3c4f51d1dab19"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04f26399e0c10f7ac64c208d49a5460e4c2fb374cabc7818c097a510c3d6e4d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f26399e0c10f7ac64c208d49a5460e4c2fb374cabc7818c097a510c3d6e4d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04f26399e0c10f7ac64c208d49a5460e4c2fb374cabc7818c097a510c3d6e4d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d8f8f03a5db74d57ec8c52b2c48519472c08200c3cfc96134b2757f96555620"
    sha256 cellar: :any_skip_relocation, ventura:       "4d8f8f03a5db74d57ec8c52b2c48519472c08200c3cfc96134b2757f96555620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f26399e0c10f7ac64c208d49a5460e4c2fb374cabc7818c097a510c3d6e4d8"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.4.tgz"
    sha256 "0d5484af2d1547607f8cac9133431cc175c702ea9bffdf6eb446cc1f492da2ac"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
