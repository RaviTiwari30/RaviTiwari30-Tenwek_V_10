#region All Namespaces
using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
#endregion All Namespaces
/// <summary>
/// <CreatedBy>Satyendra </CreatedBy>
/// <CreatedOn>on 20-09-2007</CreatedOn>
/// 
/// Summary description for Patient_LabObservation_OPD
/// </summary>
public class Patient_LabObservation_OPD
{

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;


    public Patient_LabObservation_OPD()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Patient_LabObservation_OPD(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }



    public string Flag
    {
        get;
        set;
    }
    public int ID
    {
        get;
        set;
    }

    public string LabObservation_ID
    {
        get;
        set;
    }
    public string Test_ID
    {
        get;
        set;
    }
    public DateTime ResultDateTime
    {
        get;
        set;
    }

    public string Value
    {
        get;
        set;
    }
    public string Description
    {
        get;
        set;
    }
    public string MinValue
    {
        get;
        set;
    }
    public string MaxValue
    {
        get;
        set;
    }
    public string LabObservationName
    {
        get;
        set;

    }

    public float Priorty
    {
        get;
        set;

    }
    public float InvPriorty
    {
        get;
        set;
    }
    public string ReadingFormat
    {
        get;
        set;
    }

    public string DisplayReading
    {
        get;
        set;
    }

    public int IsOrganism
    {
        get;
        set;
    }

    public string OrganismID
    {
        get;
        set;
    }

    public string ParamEnteredBy
    {
        get;
        set;
    }
    public string ParamEnteredByName
    {
        get;
        set;
    }
    public DateTime dtMacEntry
    {
        get;
        set;
    }
    public string MacReading
    {
        get;
        set;
    }
    public int MachineID
    {
        get;
        set;
    }
    public string MachineName
    {
        get;
        set;
    }
    public string LedgerTransactionNo
    {
        get;
        set;
    }




    public string Method
    {
        get;
        set;
    }
    public int PrintMethod
    {
        get;
        set;
    }

    public int IsCommentField
    {
        get;
        set;
    }

    public int ResultRequiredField
    {
        get;
        set;
    }
    public int IsCritical
    {
        get;
        set;
    }



    public string MinCritical
    {
        get;
        set;
    }

    public string MaxCritical
    {
        get;
        set;
    }



    public int Approved
    {
        get;
        set;
    }


    public string ApprovedBy
    {
        get;
        set;
    }


    public DateTime ApprovedDate
    {
        get;
        set;
    }


    public string ApprovedName
    {
        get;
        set;
    }


    public string ResultEnteredBy
    {
        get;
        set;
    }


    public DateTime ResultEnteredDate
    {
        get;
        set;
    }


    public string ResultEnteredName
    {
        get;
        set;
    }


    public string AbnormalValue
    {
        get;
        set;
    }
    public int IsBold
    {
        get;
        set;
    }
    public int IsUnderLine
    {
        get;
        set;
    }

    public int IsMic
    {
        get;
        set;
    }

    public int PrintSeparate
    {
        get;
        set;
    }

    public int ShowDeltaReport
    {
        get;
        set;
    }
    public string Value1
    {
        get;
        set;
    }

    StringBuilder objSQL = new StringBuilder();

    public int Insert()
    {
        try
        {
            int iPkValue;

            objSQL.Append("INSERT INTO patient_labobservation_OPD(LabObservation_ID, ResultDateTime, `Value`, Description,Test_ID,`MinValue`,`MaxValue`,LabObservationName,Priorty,InvPriorty,ReadingFormat,DisplayReading,IsOrganism,OrganismID,ParamEnteredBy,ParamEnteredByName,MacReading,dtMacEntry,MachineID,Method,PrintMethod,LedgerTransactionNo,`IsCommentField`,`ResultRequiredField`,`IsCritical`,`MinCritical`,`MaxCritical`,`Approved`,`ApprovedBy`,`ApprovedDate`,`ApprovedName`,`ResultEnteredBy`,`ResultEnteredDate`,`ResultEnteredName`,`AbnormalValue`,`IsBold`,`IsUnderLine`,`IsMic`,`PrintSeparate`,`flag`,`MachineName`,ShowDeltaReport,Value1)");
            objSQL.Append("VALUES (@LabObservation_ID, @Result_Date, @Value, @Description,@Test_ID,@MinValue,@MaxValue,@LabObservationName,@Priorty,@InvPriorty,@ReadingFormat,@DisplayReading,@IsOrganism,@OrganismID,@ParamEnteredBy,@ParamEnteredByName,@MacReading,@dtMacEntry,@MachineID,@Method,@PrintMethod,@LedgerTransactionNo,@IsCommentField,@ResultRequiredField,@IsCritical,@MinCritical,@MaxCritical,@Approved,@ApprovedBy,@ApprovedDate,@ApprovedName,@ResultEnteredBy,@ResultEnteredDate,@ResultEnteredName,@AbnormalValue,@IsBold,@IsUnderLine,@IsMic,@PrintSeparate,@Flag,@MachineName,@ShowDeltaReport,@Value1)");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@LabObservation_ID", LabObservation_ID),
                new MySqlParameter("@Result_Date", ResultDateTime),
                new MySqlParameter("@Value", Value),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Test_ID", Test_ID),
                new MySqlParameter("@MinValue", MinValue),
                new MySqlParameter("@MaxValue", MaxValue),
                new MySqlParameter("@LabObservationName", LabObservationName),
                new MySqlParameter("@Priorty", Priorty),
                new MySqlParameter("@InvPriorty", InvPriorty),
                new MySqlParameter("@ReadingFormat", ReadingFormat),
                new MySqlParameter("@DisplayReading", DisplayReading),
                new MySqlParameter("@IsOrganism", IsOrganism),
                new MySqlParameter("@OrganismID", OrganismID),
                new MySqlParameter("@ParamEnteredBy", ParamEnteredBy),
                new MySqlParameter("@ParamEnteredByName", ParamEnteredByName),
                new MySqlParameter("@MacReading", MacReading),
                new MySqlParameter("@dtMacEntry", dtMacEntry),
                new MySqlParameter("@MachineID", MachineID),
                new MySqlParameter("@Method", Method),
                new MySqlParameter("@PrintMethod", PrintMethod),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                new MySqlParameter("@IsCommentField", IsCommentField),
                new MySqlParameter("@ResultRequiredField", ResultRequiredField),
                new MySqlParameter("@IsCritical", IsCritical),
                new MySqlParameter("@MinCritical", MinCritical),
                new MySqlParameter("@MaxCritical", MaxCritical),

              new MySqlParameter("@Approved", Approved),
             new MySqlParameter("@ApprovedBy", ApprovedBy),
             new MySqlParameter("@ApprovedDate", ApprovedDate),
             new MySqlParameter("@ApprovedName", ApprovedName),
             new MySqlParameter("@ResultEnteredBy", ResultEnteredBy),
             new MySqlParameter("@ResultEnteredDate", ResultEnteredDate),
             new MySqlParameter("@ResultEnteredName", ResultEnteredName),
             new MySqlParameter("@AbnormalValue", AbnormalValue),
             new MySqlParameter("@IsBold", IsBold),
             new MySqlParameter("@IsUnderLine", IsUnderLine),
             new MySqlParameter("@IsMic", IsMic),
             new MySqlParameter("@PrintSeparate", PrintSeparate),
             new MySqlParameter("@Flag", Flag),
              new MySqlParameter("@MachineName", MachineName), new MySqlParameter("@ShowDeltaReport", ShowDeltaReport),new MySqlParameter("@Value1", Value1)
                );
            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            ex = new Exception(objSQL.ToString());
            //Util.WriteLog(objSQL.ToString());
            //ClassLog objerror = new ClassLog();
            //objerror.errLog(objSQL.ToString());


            throw (ex);
        }

    }




}
