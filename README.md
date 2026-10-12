cc-switch nix flake版
官方nixpkgs更新太慢，appimage版又有输入错误，该版是从deb重打包的

GitHub Actions 每天北京时间 10:17（UTC 02:17）检查上游最新正式 Release。当上游版本高于当前版本时，工作流会替换 `flake.nix` 中的版本号（包括描述、下载链接和包版本），自动提交并推送。也可以通过 Actions 页面手动运行 `Update upstream version` 工作流。
