import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { Entry, ITableSpec } from "../specs";
import { mean, mixed, normalize } from "../utils";

type field = "spec" | "n" | "functions" | "LOC" | "verified";

export default async function(data: IData): Promise<ITableSpec<field>> {
    const name = "verify";
    const columns = { spec: "l", n: "l", functions: "l", LOC: "l", verified: "l" };
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;

        const verifier = data.forGroup(group).from("verifier");
        const nm = (xs: Entry[]) => normalize(mean(xs));

        const functions = nm(await verifier.get((({ functions: x }) => x)).values());
        const LOC = nm(await verifier.get((({ linesOfCode: x }) => x)).values());
        const verified = mixed(await verifier.get((({ success: x }) => x)).values());

        return { spec, n, functions, LOC, verified };
    });
    return { name, columns, rows };
}
