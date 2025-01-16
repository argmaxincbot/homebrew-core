class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "3dee34331e8be17584673b86f992c82e4fe4e5347ca81ca4bee8e64e316f024c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea022ec916b964799d425fa401263c64536b59cfab355e4d076011384edbefa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2964b3eb0d94454163238e779e55198546211a2c4b52434a5f0807d50bd897b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65cc09b07117095028a139928b2716dd7a7c5053ccdc9ccc7e1cadcf427f559d"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    # Extract the version from the URL
    version = stable.url.match(/v([0-9]+\.[0-9]+\.[0-9]+)/)[1]
    ohai "Building whisperkit-cli version #{version}"

    # Replace the placeholder in the source code with the version from tag url
    inreplace "Sources/WhisperKitCLI/WhisperKitCLI.swift", "let VERSION: String = \"development\"", "let VERSION: String = \"#{version}\"" do |s|
      unless s.gsub!("let VERSION: String = \"development\"", "let VERSION: String = \"#{version}\"")
        raise "inreplace failed"
      end
    end

    # Build the Swift package
    system "swift", "build", "-c", "release", "--product", "whisperkit-cli", "--disable-sandbox"
    bin.install ".build/release/whisperkit-cli"
  end

  test do
    mkdir_p "#{testpath}/tokenizer"
    mkdir_p "#{testpath}/model"

    test_file = test_fixtures("test.mp3")
    output = shell_output("#{bin}/whisperkit-cli transcribe --model tiny --download-model-path #{testpath}/model " \
                          "--download-tokenizer-path #{testpath}/tokenizer --audio-path #{test_file} --verbose")
    assert_match "Transcription of test.mp3", output
  end
end
