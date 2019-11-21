import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist, msToS } from "../utils";

const name = "timing";
const columns = { contracts: "l", "example gen.": "l", synthesis: "l", verification: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: g, members: { length: n } } = group;
        const contracts = `${g} $\\times$ ${n}`;
        const metrics = data.forGroup(group).from("metrics");
        const examples = dist((await metrics.get(({ examplesTime: { value } }) => value).values()).map(msToS));
        const synthesis = dist((await metrics.get(({ synthesisTime: { value } }) => value).values()).map(msToS));
        const verification = dist((await metrics.get(({ verifyTime: { value } }) => value).values()).map(msToS));
        return { contracts, "example gen.": examples, synthesis, verification };
    });
    return { name, columns, rows };
}
