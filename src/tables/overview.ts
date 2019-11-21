import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { countTerms, dist, skeletonOfExpression } from "../utils";

const name = "overview";
const columns = { spec: "l", n: "l", expression: "l", terms: "l", verified: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const synthesis = data.forGroup(group).from("synthesis");
        const verifier = data.forGroup(group).from("verifier");
        const { name: spec, members: { length: n } } = group;
        const expression = dist(await synthesis.get(({ output: [ sim ] }) => skeletonOfExpression(sim)).values());
        const terms = dist(await synthesis.get((({ output: [ sim ] }) => countTerms(sim))).values());
        const verified = dist(await verifier.get(({ success }) => success).values());
        return { spec, n, expression, terms, verified };
    });
    return { name, columns, rows };
}
