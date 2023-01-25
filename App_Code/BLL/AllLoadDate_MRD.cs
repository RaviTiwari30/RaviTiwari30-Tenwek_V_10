using System.Data;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for mrd_AllLoaddate
/// </summary>
public class AllLoaddate_MRD
{
    public AllLoaddate_MRD()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public static DataTable dtDocMRD()
    {
        string Doc = "SELECT NAME,DocID FROM mrd_document_master ";
        return StockReports.GetDataTable(Doc);
    }
    public static void BindDocMRD(DropDownList ddlObject)
    {
        DataTable dtData = dtDocMRD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "DocID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.Visible = false;
        }

    }
    public static DataTable dtRoomMRD()
    {
        string Room = "Select * from mrd_room_master where IsActive=1 order by Name";
        return StockReports.GetDataTable(Room);
    }
    public static void BindRoomCMB(DropDownList ddlObject)
    {
        DataTable dtData = dtRoomMRD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "RmID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.Items.Clear();
            ddlObject.Controls.Clear();
        }

    }
    public static void BindRo(DropDownList ddlObject)
    {
        DataTable dtData = dtRoomMRD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "RmID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("All", "0"));
        }
        else
        {
            ddlObject.Items.Clear();
            ddlObject.Controls.Clear();
        }

    }
   
}