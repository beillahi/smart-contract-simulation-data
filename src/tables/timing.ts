import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { mean, msToS } from "../utils";

type field = "spec" | "n" | "examples" | "synthesis" | "verify";

export default async function(data: IData): Promise<ITableSpec<field>> {
    const name = "timing";
    const columns = { spec: "l", n: "l", examples: "l", synthesis: "l", verify: "l" };
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length } } = group;
        const n = length.toString();
        const metrics = data.forGroup(group).from("metrics");
        const examples = msToS(mean(await metrics.get(({ examplesTime: { value } }) => value).values()));
        const synthesis = msToS(mean(await metrics.get(({ synthesisTime: { value } }) => value).values()));
        const verify = msToS(mean(await metrics.get(({ verifyTime: { value } }) => value).values()));
        return { spec, n, examples, synthesis, verify };
    });
    return { name, columns, rows };
}
