import fs from 'fs-extra';
import path from 'path';
import { getData } from "./data";
import { latexTable, latexDocument } from "./latex";
import tables from "./tables";

async function main(...args: string[]) {
    const [ , , dataPath, tablesPath = "." ] = args;
    const data = getData(dataPath);
    try {
        const tableNames: string[] = [];

        for (const getTable of tables) {
            const table = await getTable(data);
            const tablePath = path.join(tablesPath, `${table.name}-table.tex`);
            const output = latexTable(table);
            await fs.writeFile(tablePath, output);
            tableNames.push(table.name);
        }
        const documentPath = path.join(tablesPath, `document.tex`);
        const document = latexDocument(tableNames);
        await fs.writeFile(documentPath, document);

    } catch (e) {
        console.error(e);
    }
}

main(...process.argv);
