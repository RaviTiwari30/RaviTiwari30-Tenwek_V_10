using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for IPD_Case_History
/// </summary>
public class IPD_Case_History
{
	#region All Memory Variables
	private int       _IPDCaseHistory_ID;
	private string      _Transcation_ID;
	private string _CuteGold;
	private string _Employed;
	private string      _Education;
	private string      _ProofOfIdentity;
	private string          _Consultant_ID;
	private string           _Consultant_ID1;
	private int         _ConsultantOutFlag;
	private string      _Consultant_Name;
	private System.DateTime _DateOfAdmit;
	private System.DateTime _TimeOfAdmit;
	private System.DateTime _DateOfDischarge;
	private System.DateTime _TimeOfDischarge;
	private string      _Status;
	private string      _Insurance;
	private string      _TPAName;
	private string _Employee_ID;
	private string      _Ownership;
	private string _GroupID;
	private int _IsRoomRequest;   
	private string _RequestedRoomType;
	private int _CentreID;
	private string _Hospital_Id;
	#endregion

	#region All Global Variables

	MySqlConnection objCon;
	MySqlTransaction objTrans;
	bool IsLocalConn;

	#endregion

	#region Overloaded Constructor
	public IPD_Case_History()
 {
		objCon = Util.GetMySqlCon();
		this.IsLocalConn = true;
		//21-03
		//this.TransactionID = "LHSP1";
		//this.GroupID = 1;
		//this.Ownership = "Public";
 }

	public IPD_Case_History(MySqlTransaction objTrans)
 {
		this.objTrans = objTrans;
		this.IsLocalConn = false;
 }
	#endregion

	#region Set All Property
	public virtual int  IPDCaseHistory_ID
	{
		get
		{
			return _IPDCaseHistory_ID;
		}
		set
		{
			_IPDCaseHistory_ID = value;
		}
	}
	public virtual string TransactionID
	{
		get
		{
			return _Transcation_ID;
		}
		set
		{
			_Transcation_ID = value;
		}
	}
	public virtual string CuteGold
	{
		get
		{
			return _CuteGold;
		}
		set
		{
			_CuteGold = value;
		}
	}
	public virtual string Employed
	{
		get
		{
			return _Employed;
		}
		set
		{
			_Employed = value;
		}
	}
	public virtual string Education
	{
		get
		{
			return _Education;
		}
		set
		{
			_Education = value;
		}
	}
	public virtual string ProofOfIdentity
	{
		get
		{
			return _ProofOfIdentity;
		}
		set
		{
			_ProofOfIdentity = value;
		}
	}
	public virtual string Consultant_ID
	{
		get
		{
			return _Consultant_ID;
		}
		set
		{
			_Consultant_ID = value;
		}
	}
	public virtual string Consultant_ID1
	{
		get
		{
			return _Consultant_ID1;
		}
		set
		{
			_Consultant_ID1 = value;
		}
	}

	public virtual int ConsultantOutFlag
	{
		get
		{
			return _ConsultantOutFlag;
		}
		set
		{
			_ConsultantOutFlag = value;
		}
	}

	public virtual string Consultant_Name
	{
		get
		{
			return _Consultant_Name;
		}
		set
		{
			_Consultant_Name = value;
		}
	}

	public virtual System.DateTime DateOfAdmit
	{
		get
		{
			return _DateOfAdmit;
		}
		set
		{
			_DateOfAdmit = value;
		}
	}
	public virtual System.DateTime TimeOfAdmit
	{
		get
		{
			return _TimeOfAdmit;
		}
		set
		{
			_TimeOfAdmit = value;
		}
	}
	public virtual System.DateTime DateOfDischarge
	{
		get
		{
			return _DateOfDischarge;
		}
		set
		{
			_DateOfDischarge = value;
		}
	}
	public virtual System.DateTime TimeOfDischarge
	{
		get
		{
			return _TimeOfDischarge;
		}
		set
		{
			_TimeOfDischarge = value;
		}
	}
	public virtual string Status
	{
		get
		{
			return _Status;
		}
		set
		{
			_Status = value;
		}
	}
	public virtual string Insurance
	{
		get
		{
			return _Insurance;
		}
		set
		{
			_Insurance = value;
		}
	}
	public virtual string TPAName
	{
		get
		{
			return _TPAName;
		}
		set
		{
			_TPAName = value;
		}
	}
	public virtual string Employee_ID
	{
		get
		{
			return _Employee_ID;
		}
		set
		{
			_Employee_ID = value;
		}
	}
	public virtual string Ownership
	{
		get
		{
			return _Ownership;
		}
		set
		{
			_Ownership = value;
		}
	}
	public virtual string GroupID
	{
		get
		{
			return _GroupID;
		}
		set
		{
			_GroupID = value;
		}
	}

	public int IsRoomRequest
	{
		get { return _IsRoomRequest; }
		set { _IsRoomRequest = value; }
	}

	public string RequestedRoomType
	{
		get { return _RequestedRoomType; }
		set { _RequestedRoomType = value; }
	}
	public virtual int CentreID
		{
		get
			{
			return _CentreID;
			}
		set
			{
			_CentreID = value;
			}
		}
	public virtual string Hospital_Id
		{
		get
			{
			return _Hospital_Id;
			}
		set
			{
			_Hospital_Id = value;
			}
		}   
	#endregion
		
	#region All Public Member Function
	public int Insert()
	{
		try
		{
		   int iPkValue;
			StringBuilder objSQL = new StringBuilder();
			objSQL.Append("INSERT INTO ipd_case_history(TransactionID, CuteGold, Employed, Education, ProofOfIdentity, Consultant_ID,Consultant_ID1 ,ConsultantOutFlag,Consultant_Name,DateOfAdmit ,TimeOfAdmit ,DateOfDischarge ,TimeOfDischarge ,Status ,Insurance ,TPAName ,Employee_ID ,Ownership ,GroupID,IsRoomRequest,RequestedRoomType,CentreID,Hospital_Id  )");
			objSQL.Append("VALUES (@TransactionID, @CuteGold, @Employed, @Education, @ProofOfIdentity, @Consultant_ID,@Consultant_ID1, @ConsultantOutFlag, @Consultant_Name, @DateOfAdmit, @TimeOfAdmit, @DateOfDischarge, @TimeOfDischarge, @Status, @Insurance, @TPAName,@Employee_ID,@Ownership,@GroupID,@IsRoomRequest,@RequestedRoomType,@CentreID,@Hospital_Id)");
			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}
			IPDCaseHistory_ID = Util.GetInt(IPDCaseHistory_ID);
			TransactionID = Util.GetString(TransactionID);
			CuteGold = Util.GetString(CuteGold);
			Employed = Util.GetString(Employed);
			Education = Util.GetString(Education);
			ProofOfIdentity = Util.GetString(ProofOfIdentity);
			Consultant_ID = Util.GetString(Consultant_ID);
			Consultant_ID1 = Util.GetString(Consultant_ID1);
			ConsultantOutFlag = Util.GetInt(ConsultantOutFlag);
			Consultant_Name = Util.GetString(Consultant_Name);
			DateOfAdmit = Util.GetDateTime(DateOfAdmit);
			TimeOfAdmit = Util.GetDateTime(TimeOfAdmit);
			DateOfDischarge = Util.GetDateTime(DateOfDischarge);
			TimeOfDischarge = Util.GetDateTime(TimeOfDischarge);
			Status = Util.GetString(Status);
			Insurance = Util.GetString(Insurance);
			TPAName = Util.GetString(TPAName);
			Employee_ID = Util.GetString(Employee_ID);
			Ownership = Util.GetString(Ownership);
			GroupID = Util.GetString(GroupID);
			IsRoomRequest = Util.GetInt(IsRoomRequest);
			RequestedRoomType = Util.GetString(RequestedRoomType);
			CentreID = Util.GetInt(CentreID);
			Hospital_Id = Util.GetString(Hospital_Id);
			MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

				new MySqlParameter("@IPDCaseHistory_ID",     IPDCaseHistory_ID),
				new MySqlParameter("@TransactionID", TransactionID),
				new MySqlParameter("@CuteGold", CuteGold),
				new MySqlParameter("@Employed",              Employed),
				new MySqlParameter("@Education",             Education),
				new MySqlParameter("@ProofOfIdentity",       ProofOfIdentity),
				new MySqlParameter("@Consultant_ID",         Consultant_ID),
				new MySqlParameter("@Consultant_ID1",         Consultant_ID1),
				new MySqlParameter("@ConsultantOutFlag", ConsultantOutFlag),
				new MySqlParameter("@Consultant_Name", Consultant_Name),
				new MySqlParameter("@DateOfAdmit",           DateOfAdmit),
				new MySqlParameter("@TimeOfAdmit",           TimeOfAdmit),
				new MySqlParameter("@DateOfDischarge",       DateOfDischarge),
				new MySqlParameter("@TimeOfDischarge",       TimeOfDischarge),
				new MySqlParameter("@Status",                Status),
				new MySqlParameter("@Insurance",             Insurance),
				new MySqlParameter("@TPAName",               TPAName),
				new MySqlParameter("@Employee_ID",           Employee_ID),
				new MySqlParameter("@Ownership",             Ownership),
				new MySqlParameter("@GroupID",               GroupID),
				new MySqlParameter("@IsRoomRequest",         IsRoomRequest),
				new MySqlParameter("@RequestedRoomType",     RequestedRoomType),
				 new MySqlParameter("@CentreID",     CentreID),
				  new MySqlParameter("@Hospital_Id",     Hospital_Id));                                              
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
			throw (ex);
		}

	}

	public int Update()
	{
		try
		{
			int RowAffected;
			StringBuilder objSQL = new StringBuilder();
			objSQL.Append("UPDATE ipd_case_history SET  Employed = @Employed, Education = @Education, ProofOfIdentity=@ProofOfIdentity, Consultant_ID= @Consultant_ID,Consultant_ID1=@Consultant_ID1,ConsultantOutFlag=@ConsultantOutFlag,Consultant_Name=@Consultant_Name, DateOfAdmit= @DateOfAdmit, TimeOfAdmit= @TimeOfAdmit, DateOfDischarge= @DateOfDischarge, TimeOfDischarge= @TimeOfDischarge, Status =@Status, Insurance= @Insurance, TPAName= @TPAName, Employee_ID= @Employee_ID,Ownership =@Ownership, GroupID= @GroupID,IsRoomRequest=@IsRoomRequest,RequestedRoomType=@RequestedRoomType WHERE TransactionID = @TransactionID ");
						
			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}
			//IPDCaseHistory_ID = Util.GetInt(IPDCaseHistory_ID);
			TransactionID = Util.GetString(TransactionID);
			CuteGold = Util.GetString(CuteGold);
			Employed = Util.GetString(Employed);
			Education = Util.GetString(Education);
			ProofOfIdentity = Util.GetString(ProofOfIdentity);
			Consultant_ID = Util.GetString(Consultant_ID);
			Consultant_ID1 = Util.GetString(Consultant_ID1);
			ConsultantOutFlag = Util.GetInt(ConsultantOutFlag);
			Consultant_Name = Util.GetString(Consultant_Name);
			DateOfAdmit = Util.GetDateTime(DateOfAdmit);
			TimeOfAdmit = Util.GetDateTime(TimeOfAdmit);
			DateOfDischarge = Util.GetDateTime(DateOfDischarge);
			TimeOfDischarge = Util.GetDateTime(TimeOfDischarge);
			Status = Util.GetString(Status);
			Insurance = Util.GetString(Insurance);
			TPAName = Util.GetString(TPAName);
			Employee_ID = Util.GetString(Employee_ID);
			Ownership = Util.GetString(Ownership);
			GroupID = Util.GetString(GroupID);
			IsRoomRequest = Util.GetInt(IsRoomRequest);
			RequestedRoomType = Util.GetString(RequestedRoomType);

			RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

			   
				new MySqlParameter("@Employed",        Employed),
				new MySqlParameter("@Education",       Education),
				new MySqlParameter("@ProofOfIdentity", ProofOfIdentity),
				new MySqlParameter("@Consultant_ID",   Consultant_ID),
				new MySqlParameter("@Consultant_ID1", Consultant_ID1),
				new MySqlParameter("@ConsultantOutFlag", ConsultantOutFlag),
				new MySqlParameter("@Consultant_Name", Consultant_Name),
				new MySqlParameter("@DateOfAdmit",     DateOfAdmit),
				new MySqlParameter("@TimeOfAdmit",     TimeOfAdmit),
				new MySqlParameter("@DateOfDischarge", DateOfDischarge),
				new MySqlParameter("@TimeOfDischarge", TimeOfDischarge),
				new MySqlParameter("@Status",          Status),
				new MySqlParameter("@Insurance",       Insurance),
				new MySqlParameter("@TPAName",         TPAName),
				new MySqlParameter("@Employee_ID",     Employee_ID),
				new MySqlParameter("@Ownership",       Ownership),
				new MySqlParameter("@GroupID",         GroupID),
				new MySqlParameter("@TransactionID", TransactionID),
				new MySqlParameter("@IsRoomRequest", IsRoomRequest),
				new MySqlParameter("@RequestedRoomType", RequestedRoomType));
				

			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}
			return RowAffected;

		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objTrans != null) this.objTrans.Rollback();
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			throw (ex);
		}

	}

	public int Delete(int iPkValue)
	{
		this.IPDCaseHistory_ID = iPkValue;
		return this.Delete();
	}

	public int Delete()
	{
		try
		{
			int iRetValue;
			StringBuilder objSQL = new StringBuilder();
			objSQL.Append("DELETE FROM ipd_case_history WHERE IPDCaseHistory_ID = ?");

			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}

			iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

				new MySqlParameter("IPDCaseHistory_ID", IPDCaseHistory_ID));
			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}
			return iRetValue;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objTrans != null) this.objTrans.Rollback();
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			throw (ex);
		}
	}

	public bool Load()
	{
		DataTable dtTemp;

		try
		{

			string sSQL = "SELECT * FROM ipd_case_history WHERE IPDCaseHistory_ID = ?";

			if (IsLocalConn)
			{
				this.objCon.Open();
				this.objTrans = this.objCon.BeginTransaction();
			}

			dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@IPDCaseHistory_ID", IPDCaseHistory_ID)).Tables[0];

			if (IsLocalConn)
			{
				this.objTrans.Commit();
				this.objCon.Close();
			}

			if (dtTemp.Rows.Count > 0)
			{
				this.SetProperties(dtTemp);
				return true;
			}
			else
				return false;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objTrans != null) this.objTrans.Rollback();
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			string sParams = "IPDCaseHistory_ID=" + this.IPDCaseHistory_ID.ToString();
			throw (ex);
		}

	}

	/// <summary>
	/// Loads the specified i pk value.
	/// </summary>
	/// <param name="iPkValue">The i pk value.</param>
	/// <returns></returns>
	public bool Load(int iPkValue)
	{
		this.IPDCaseHistory_ID = iPkValue;
		return this.Load();
	}

	#endregion All Public Member Function

	#region Helper Private Function
	private void SetProperties(DataTable dtTemp)
	{
		this.IPDCaseHistory_ID = Util.GetInt(dtTemp.Rows[0][AllTables.IPD_Case_History.IPDCaseHistory_ID]);
		this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.TransactionID]);
		this.CuteGold = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.CuteGold]);
		this.Employed = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Employed]);
		this.Education = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Education]);
		this.ProofOfIdentity = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.ProofOfIdentity]);
		this.Consultant_ID = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Consultant_ID]);
		this.Consultant_ID1 = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Consultant_ID1]);
		this.ConsultantOutFlag = Util.GetInt(dtTemp.Rows[0][AllTables.IPD_Case_History.ConsultantOutFlag]);
		this.Consultant_Name = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Consultant_Name]);
		
		this.DateOfAdmit = Util.GetDateTime(dtTemp.Rows[0][AllTables.IPD_Case_History.DateOfAdmit]);
		this.TimeOfAdmit = Util.GetDateTime(dtTemp.Rows[0][AllTables.IPD_Case_History.DateOfAdmit]);
		this.DateOfDischarge = Util.GetDateTime(dtTemp.Rows[0][AllTables.IPD_Case_History.DateOfDischarge]);
		this.TimeOfDischarge = Util.GetDateTime(dtTemp.Rows[0][AllTables.IPD_Case_History.TimeOfDischarge]);
		this.Status = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Status]);
		this.Insurance = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Insurance]);
		this.TPAName = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.TPAName]);
		this.Employee_ID = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Employee_ID]);
		this.Ownership = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.Ownership]);
		this.GroupID = Util.GetString(dtTemp.Rows[0][AllTables.IPD_Case_History.GroupID]);
	}
	#endregion
}
