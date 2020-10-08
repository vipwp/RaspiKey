const chidProcess = require('child_process');
const { writeFileSync } = require('fs');
var fs = require('fs');

const longSHA = chidProcess.execSync("git rev-parse HEAD").toString().trim();
const shortSHA = chidProcess.execSync("git rev-parse --short HEAD").toString().trim();
const branch = chidProcess.execSync('git rev-parse --abbrev-ref HEAD').toString().trim();
const authorName = chidProcess.execSync("git log -1 --pretty=format:'%an'").toString().trim();
const commitTime = chidProcess.execSync("git log -1 --pretty=format:'%cd'").toString().trim();
const commitMsg = chidProcess.execSync("git log -1 --pretty=%B").toString().trim();
const totalCommitCount = chidProcess.execSync("git rev-list --count HEAD").toString().trim();
const majorMinor = fs.readFileSync('../version.txt','utf8');

const versionInfo = {
    shortSHA: shortSHA,
    SHA : longSHA,
    branch: branch,
    lastCommitAuthor: authorName,
    lastCommitTime: commitTime,
    lastCommitMessage: commitMsg,
    lastCommitNumber: totalCommitCount,
    majorMinor: majorMinor
}

const versionInfoJson = JSON.stringify(versionInfo, null, 2);

writeFileSync('src/.git-version.json', versionInfoJson);