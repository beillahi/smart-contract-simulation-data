import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { mean, normalize } from "../utils";

export default async function(data: IData): Promise<ITableSpec<"spec" | "n" | "expression" | "verified">> {
    const name = "overview";
    const columns = { spec: "l", n: "l", expression: "l", verified: "l" };

    const rows = await perExampleGroup(async (group) => {
        const synthesis = data.forGroup(group).from("synthesis");
        const verifier = data.forGroup(group).from("verifier");
        const { name: spec, members: { length: n } } = group;
        const expression = normalize(mean(await synthesis.get(({ output: [ sim ] }) => sim.length).values()));
        const results = await verifier.get(({ success }) => success).values();
        const [ firstResult ] = results;
        const verified = results.every((result) => result === firstResult) ? firstResult : undefined;
        return { spec, n, expression, verified };
    });
    return { name, columns, rows };
}
