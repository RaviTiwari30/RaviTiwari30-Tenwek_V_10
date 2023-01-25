using System.Data;

/// <summary>
/// Summary description for Items
/// </summary>
public class Items
{
    public Items()
    {
    }

    public DataTable LoadItems(string Itemname)
    {
        AllSelectQuery aq = new AllSelectQuery();
        return aq.LoadItems(Itemname);
    }

    public DataTable LoadSets()
    {
        AllSelectQuery aq = new AllSelectQuery();
        return aq.LoadSets();
    }
}