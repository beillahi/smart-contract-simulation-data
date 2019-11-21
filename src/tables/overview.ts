import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist, skeletonOfExpression } from "../utils";

const name = "overview";
const columns = { spec: "l", n: "l", expression: "l", verified: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const synthesis = data.forGroup(group).from("synthesis");
        const verifier = data.forGroup(group).from("verifier");
        const { name: spec, members: { length: n } } = group;
        const expression = dist(await synthesis.get(({ output: [ sim ] }) => sim === undefined ? "?" : skeletonOfExpression(sim)).values());
        const verified = dist(await verifier.get(({ success }) => success).values());
        return { spec, n, expression, verified };
    });
    return { name, columns, rows };
}
