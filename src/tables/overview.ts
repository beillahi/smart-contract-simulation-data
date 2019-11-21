import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist, skeletonOfExpression } from "../utils";

const name = "overview";
const simColumn = "simulation relations"
const columns = { contracts: "l", [simColumn]: "l", verified: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const synthesis = data.forGroup(group).from("synthesis");
        const verifier = data.forGroup(group).from("verifier");
        const { name: g, members: { length: n } } = group;
        const contracts = `${g} $\\times$ ${n}`;
        const expression = dist(await synthesis.get(({ output: [ sim ] }) => skeletonOfExpression(sim)).values());
        const verified = dist(await verifier.get(({ success }) => success).values());
        return { contracts, [simColumn]: expression, verified };
    });
    return { name, columns, rows };
}
