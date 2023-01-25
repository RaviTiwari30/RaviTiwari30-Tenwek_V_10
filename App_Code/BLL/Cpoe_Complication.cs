using System.Data;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Cpoe_Complication
/// </summary>
public class Cpoe_Complication
{
	public Cpoe_Complication()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public static DataTable dtinfection()
    {
        return StockReports.GetDataTable("SELECT infectionID,infectionName from cpoe_com_infectionmaster where IsActive=1");

    }
    public static void bindInfection(CheckBoxList chkObject)
    {
        DataTable dtData = dtinfection();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "infectionName";
            chkObject.DataValueField = "infectionID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtimplant()
    {
        return StockReports.GetDataTable("SELECT implantID,implantName from cpoe_com_implantmaster where IsActive=1");
  
    }
    public static void bindimplant(CheckBoxList chkObject)
    {
        DataTable dtData = dtimplant();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "implantName";
            chkObject.DataValueField = "implantID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtScrewMalposition()
    {
        return StockReports.GetDataTable("SELECT ScrewMalpositionID,ScrewMalpositionName from cpoe_com_screwmalpositionmaster where IsActive=1");
       
    }
    public static void bindScrewMalposition(CheckBoxList chkObject)
    {
        DataTable dtData = dtScrewMalposition();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "ScrewMalpositionName";
            chkObject.DataValueField = "ScrewMalpositionID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtRadiograph()
    {
        return StockReports.GetDataTable("SELECT RadiographID,RadiographName from cpoe_com_radiographmaster where IsActive=1");
    }
    public static void bindRadiograph(CheckBoxList chkObject)
    {
        DataTable dtData = dtRadiograph();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "RadiographName";
            chkObject.DataValueField = "RadiographID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtwound()
    {
        return StockReports.GetDataTable("SELECT woundID,woundName from cpoe_com_woundmaster where IsActive=1");
    }
    public static void bindwound(CheckBoxList chkObject)
    {
        DataTable dtData = dtwound();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "woundName";
            chkObject.DataValueField = "woundID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtNeurologic()
    {
        return StockReports.GetDataTable("SELECT NeurologicID,NeurologicName from cpoe_com_neurologicmaster where IsActive=1");
    }
    public static void bindNeurologic(CheckBoxList chkObject)
    {
        DataTable dtData = dtNeurologic();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "NeurologicName";
            chkObject.DataValueField = "NeurologicID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtmortality()
    {
        return StockReports.GetDataTable("SELECT mortalityID,mortalityName from cpoe_com_mortalitymaster where IsActive=1");

    }
    public static void bindmortality(CheckBoxList chkObject)
    {
        DataTable dtData = dtmortality();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "mortalityName";
            chkObject.DataValueField = "mortalityID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtoperative()
    {
        return StockReports.GetDataTable("SELECT operativeID,operativeName from cpoe_com_operativemaster where IsActive=1");

    }
    public static void bindoperative(CheckBoxList chkObject)
    {
        DataTable dtData = dtoperative();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "operativeName";
            chkObject.DataValueField = "operativeID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtothercomplications()
    {
        return StockReports.GetDataTable("SELECT OtherComplicationsID,OtherComplicationsName from cpoe_com_othercomplicationsmaster where IsActive=1");
        
    }
    public static void bindothercomplications(CheckBoxList chkObject)
    {
        DataTable dtData = dtothercomplications();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "OtherComplicationsName";
            chkObject.DataValueField = "OtherComplicationsID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtTreatment()
    {
        return StockReports.GetDataTable("SELECT TreatmentID,TreatmentName from cpoe_com_treatmentmaster where IsActive=1");
  
    }
    public static void bindTreatment(CheckBoxList chkObject)
    {
        DataTable dtData = dtTreatment();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "TreatmentName";
            chkObject.DataValueField = "TreatmentID";
            chkObject.DataBind();
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
}