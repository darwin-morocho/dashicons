module.exports = {
  apps: [
    {
      name: "cloudicons",
      script: "dist/index.js",
      instances: 1,
      exec_mode: "cluster",
    },
  ],
};
