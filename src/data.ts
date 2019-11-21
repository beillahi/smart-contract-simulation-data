import cp from "child_process";
import fs from "fs-extra";
import path from "path";
import { IGroup } from "./examples";

type IEvaluatorData = object[];

type IEvaluatorQueryData = object[];

interface ISynthesisInputData {
    examples: {
        positive: object[];
        negative: object[];
    };
    expressions: object[];
    features: object[];
}

interface IExamplesData {
    transactionHistory: object[];
    examples: {
        positive: object[];
        negative: object[];
    };
}

interface ISynthesisData {
    features: object[];
    output: string[];
}

interface IVerifierData {
    success: boolean;
    output: string[];
    errors: string[];
    linesOfCode: number;
}

interface ISimulationMetrics {
    examplesTime: IMetric;
    synthesisTime: IMetric;
    verifyTime: IMetric;
    states: IMetric;
    traces: IMetric;
}

interface IMetric {
    value: number;
}

interface IDataTypes {
    metrics: ISimulationMetrics;
    examples: IExamplesData;
    synthesis: ISynthesisData;
    verifier: IVerifierData;
    evaluator: IEvaluatorData;
    evaluatorQueries: IEvaluatorQueryData;
    synthesisInput: ISynthesisInputData;
}

const dataSources = {
    evaluator: "evaluator-data.jsonl",
    evaluatorQueries: "evaluator-queries.jsonl",
    examples: "examples-data.json",
    metrics: "simulation-metrics.json",
    synthesis: "synthesis-data.json",
    synthesisInput: "synthesis-input-data.json",
    verifier: "verifier-data.json",
};

export async function getExampleLoc(dataPath: string, example: string): Promise<number | undefined> {
    const examplePath = path.join(dataPath, example);
    const command = `ls ${examplePath}/*.sol | grep -v -e Context -e Examples -e exemplified | xargs wc -l | tail -n 1 | sed 's/ *//' | cut -d' ' -f 1`;
    const output = cp.execSync(command).toString();
    const n = parseInt(output);
    return Number.isFinite(n) ? n : undefined;
}

export async function getExampleData<T extends keyof IDataTypes>(
        dataPath: string, example: string, source: T): Promise<IDataTypes[T] | undefined> {

    const examplePath = path.join(dataPath, example, dataSources[source]);
    try {
        if (path.extname(examplePath) === ".json") {
            const data = await fs.readJSON(examplePath) as IDataTypes[T];
            return data;

        } else if (path.extname(examplePath) === ".jsonl") {
            const buffer = await fs.readFile(examplePath);
            const lines = buffer.toString().split("\n");
            const data = lines
                .map((line) => line.length > 0 ? JSON.parse(line) : undefined)
                .filter((d) => d !== undefined) as IDataTypes[T];
            return data;
        }

    } catch (e) {
        return undefined;
    }
}

export interface IData {
    forExample(example: string): IDataForExample;
    forGroup(group: IGroup): IDataForGroup;
    loc(example: string): Promise<number | undefined>;
}

interface IDataForExample {
    from<T extends keyof IDataTypes>(source: T): IDataFromSource<T>;
}

interface IDataFromSource<T extends keyof IDataTypes> {
    get<U>(f: (_: IDataTypes[T]) => U): Promise<U | undefined>;
}

interface IDataForGroup{
    from<T extends keyof IDataTypes>(source: T): IGroupDataFromSource<T>;
}

interface IGroupDataFromSource<T extends keyof IDataTypes> {
    get<U>(f: (_: IDataTypes[T]) => U): IGroupDataFromSourceResults<U>;
}

interface IGroupDataFromSourceResults<T> {
    keys(): Promise<string[]>;
    values(): Promise<T[]>;
    entries(): Promise<Array<[string, T]>>;
}

export function getData(dataPath: string): IData {
    return {
        forExample(example: string): IDataForExample {
            return {
                from<T extends keyof IDataTypes>(source: T): IDataFromSource<T> {
                    return {
                        async get<U>(f: (_: IDataTypes[T]) => U) {
                            const data = await getExampleData<T>(dataPath, example, source);

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
                from<T extends keyof IDataTypes>(source: T) {
                    return {
                        get<U>(f: (_: IDataTypes[T]) => U) {
                            const { members } = group;
                            const results = Promise.all(members.map(async (example) => {
                                const data = await getExampleData<T>(dataPath, example, source);

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
                                async entries(): Promise<Array<[string, U]>> {
                                    return result.then((r) => Object.entries(r));
                                },
                                async keys(): Promise<string[]> {
                                    return result.then((r) => Object.keys(r));
                                },
                                async values(): Promise<U[]> {
                                    return result.then((r) => Object.values(r));
                                },
                            };
                        },
                    };
                },
            };
        },
        loc(example: string) {
            return getExampleLoc(dataPath, example);
        }
    };
}
