import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { countUnVerifiedFunctions, countVerifiedFunctions, dist } from "../utils";

const name = "verify";
const locColumn = "lines of code";
const verifiedColumn = "verified fns.";
const columns = { contracts: "l", [locColumn]: "l", [verifiedColumn]: "l", unverified: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: g, members: { length: n } } = group;
        const contracts = `${g} $\\times$ ${n}`;
        const verifier = data.forGroup(group).from("verifier");
        const verified = dist(await verifier.get((({ output }) => countVerifiedFunctions(output))).values());
        const unverified = dist(await verifier.get((({ output }) => countUnVerifiedFunctions(output))).values());
        const LOC = dist(await Promise.all(group.members.map((example) => data.loc(example))));
        return { contracts, [locColumn]: LOC, [verifiedColumn]: verified, unverified };
    });
    return { name, columns, rows };
}
