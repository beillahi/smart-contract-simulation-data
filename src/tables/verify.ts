import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist, mixed } from "../utils";

const name = "verify";
const columns = { spec: "l", n: "l", functions: "l", LOC: "l", verified: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;
        const verifier = data.forGroup(group).from("verifier");
        const functions = dist(await verifier.get((({ functions: x }) => x)).values());
        const LOC = dist(await verifier.get((({ linesOfCode: x }) => x)).values());
        const verified = mixed(await verifier.get((({ success: x }) => x)).values());

        return { spec, n, functions, LOC, verified };
    });
    return { name, columns, rows };
}
