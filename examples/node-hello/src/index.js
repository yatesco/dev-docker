const chalk = require("chalk");
const dayjs = require("dayjs");

const now = dayjs().format("YYYY-MM-DD HH:mm:ss");
console.log(chalk.green(`hello from node example at ${now}`));