import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist, msToS } from "../utils";

const name = "timing";
const columns = { spec: "l", n: "l", examples: "l", synthesis: "l", verify: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length } } = group;
        const n = length.toString();
        const metrics = data.forGroup(group).from("metrics");
        const examples = dist((await metrics.get(({ examplesTime: { value } }) => value).values()).map(msToS));
        const synthesis = dist((await metrics.get(({ synthesisTime: { value } }) => value).values()).map(msToS));
        const verify = dist((await metrics.get(({ verifyTime: { value } }) => value).values()).map(msToS));
        return { spec, n, examples, synthesis, verify };
    });
    return { name, columns, rows };
}
