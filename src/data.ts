import fs from "fs-extra";
import path from "path";
import { IGroup } from "./examples";

const dataSources = {
    evaluator: "evaluator-data.jsonl",
    evaluatorQueries: "evaluator-queries.jsonl",
    examples: "examples-data.json",
    metrics: "simulation-metrics.json",
    synthesis: "synthesis-data.json",
    synthesisInput: "synthesis-input-data.json",
    verifier: "verifier-data.json",
};

export async function getExampleData<T>(
        dataPath: string, example: string, source: keyof typeof dataSources): Promise<T | undefined> {

    const examplePath = path.join(dataPath, example, dataSources[source]);
    try {
        if (path.extname(examplePath) === ".json") {
            const data = await fs.readJSON(examplePath) as T;
            return data;

        } else if (path.extname(examplePath) === ".jsonl") {
            const buffer = await fs.readFile(examplePath);
            const lines = buffer.toString().split("\n");

            const data: any = [];
            for (const line of lines) {
                if (line.length > 0) {
                    data.push(JSON.parse(line));
                }
            }
            return data;
        }

    } catch (e) {
        ;
    }

    return undefined;
}

export interface IData {
    forExample(example: string): IDataForExample;
    forGroup(group: IGroup): IDataForGroup;
}

interface IDataForExample {
    from(source: keyof typeof dataSources): IDataFromSource;
}

interface IDataFromSource {
    get(f: (_: any) => any): any;
}

interface IDataForGroup {
    from(source: keyof typeof dataSources): IGroupDataFromSource;
}

interface IGroupDataFromSource {
    get(f: (_: any) => any): IGroupDataFromSourceResults;
}

interface IGroupDataFromSourceResults {
    keys(): Promise<string[]>;
    values(): Promise<any[]>;
    entries(): Promise<Array<[string,any]>>;
}

export function getData(dataPath: string): IData {
    return {
        forExample(example: string): IDataForExample {
            return {
                from(source: keyof typeof dataSources): IDataFromSource {
                    return {
                        async get(f: (_: any) => any) {
                            const data = await getExampleData(dataPath, example, source);

                            if (data === undefined) {
                                return undefined;
                            }

                            try {
                                return f(data);
                            } catch (e) {
                                return undefined;
                            }
                        },
                    };
                },
            };
        },

        forGroup(group: IGroup) {
            return {
                from(source: keyof typeof dataSources) {
                    return {
                        get(f: (_: any) => any) {
                            const { members } = group;
                            const results = Promise.all(members.map<Promise<[string, any]>>(async (example) => {
                                const data = await getExampleData(dataPath, example, source);

                                if (data === undefined) {
                                    return [example, undefined];
                                }

                                try {
                                    return [example, f(data)];
                                } catch (e) {
                                    return [example, undefined];
                                }
                            }));
                            const result = results.then((rs) => Object.fromEntries(rs));
                            return {
                                async entries(): Promise<Array<[string, any]>> {
                                    return result.then((r) => Object.entries(r));
                                },
                                async keys(): Promise<string[]> {
                                    return result.then((r) => Object.keys(r));
                                },
                                async values(): Promise<any[]> {
                                    return result.then((r) => Object.values(r));
                                },
                            };
                        },
                    };
                },
            };
        },
    };
}
