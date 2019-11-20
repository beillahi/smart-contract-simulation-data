import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist } from "../utils";

const name = "examples";
const columns = { spec: "l", n: "l", traces: "l", states: "l", txs: "l", pos: "l", neg: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;
        const examples = data.forGroup(group).from("examples");
        const traces = dist(await examples.get((({ traces: { length } }) => length)).values());
        const states = dist(await examples.get((({ states: { length } }) => length)).values());
        const txs = dist(await examples.get((({ transactionHistory: { length } }) => length)).values());
        const pos = dist(await examples.get((({ examples: { positive: { length } }}) => length)).values());
        const neg = dist(await examples.get((({ examples: { negative: { length } }}) => length)).values());
        return { spec, n, traces, states, txs, pos, neg };
    });
    return { name, columns, rows };
}
