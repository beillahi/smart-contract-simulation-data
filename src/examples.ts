import fs from "fs-extra";
import path from "path";

const configPath = path.join(__dirname, "..", "configs");

export interface IGroup {
    name: string;
    members: string[];
}

export async function perExampleGroup<T>(f: (_: IGroup) => Promise<T>) {
    const groups = [...await getExampleGroups()];
    return Promise.all(groups.map(f));
}

export async function getExampleGroups(): Promise<Iterable<IGroup>> {
    const examples = await getExamples();
    const groupNames = [...new Set(examples.map(groupOf))];
    const groups = groupNames.map((name) => {
        const members = examples.filter(isMember(name));
        return { name, members };
    });
    return groups;
}

function isMember(group: string) {
    return (example: string) => groupOf(example) === group;
}

function groupOf(example: string) {
    return example.substring(0, example.lastIndexOf("-")).replace(/-contracts/, "");
}

async function getExamples() {
    const configs = await getConfigs();
    const examples = configs.map((p) => path.basename(p, ".json"));
    return examples;
}

async function getConfigs() {
    const listing = await fs.readdir(configPath);
    return listing;
}
