import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { countUnVerifiedFunctions, countVerifiedFunctions, dist } from "../utils";

const name = "verify";
const columns = { spec: "l", n: "l", LOC: "l", verif: "l", fail: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;
        const verifier = data.forGroup(group).from("verifier");
        const verif = dist(await verifier.get((({ output }) => countVerifiedFunctions(output))).values());
        const fail = dist(await verifier.get((({ output }) => countUnVerifiedFunctions(output))).values());
        const LOC = dist(await verifier.get((({ linesOfCode: x }) => x)).values());
        // const verified = dist(await verifier.get((({ success: x }) => x)).values());

        return { spec, n, LOC, verif, fail };
    });
    return { name, columns, rows };
}
