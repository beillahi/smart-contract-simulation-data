import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { dist } from "../utils";

const name = "examples";
const columns = { contracts: "l", transactions: "l", traces: "l", states: "l", positive: "l", negative: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: g, members: { length: n } } = group;
        const contracts = `${g} $\\times$ ${n}`;
        const examples = data.forGroup(group).from("examples");
        const metrics = data.forGroup(group).from("metrics");
        const traces = dist(await metrics.get((({ traces: { value } }) => value)).values());
        const states = dist(await metrics.get((({ states: { value } }) => value)).values());
        const transactions = dist(await examples.get((({ transactionHistory: { length } }) => length)).values());
        const positive = dist(await examples.get((({ examples: { positive: { length } }}) => length)).values());
        const negative = dist(await examples.get((({ examples: { negative: { length } }}) => length)).values());
        return { contracts, transactions, traces, states, positive, negative };
    });
    return { name, columns, rows };
}
