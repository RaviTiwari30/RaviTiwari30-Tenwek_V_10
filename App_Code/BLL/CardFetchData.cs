using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for CardFetchData
/// </summary>
/// 

public class GetMenberDetails
{
    public List<CardFetchData> content { get; set; }
}
public class CardFetchData
{
    public string medicalaid_code { get; set; }
    public string medicalaid_name { get; set; }
    public string policy_id { get; set; }
    public string medicalaid_scheme_code { get; set; }
    public string medicalaid_scheme_name { get; set; }
    public string medicalaid_number { get; set; }

    public string member_name { get; set; }
    public string global_id { get; set; }
    public string card_serial_number { get; set; }
    public string medicalaid_plan { get; set; }
    public string patient_number { get; set; }
    public string medicalaid_regdate { get; set; }

    public string medicalaid_expiry { get; set; }
    public string patient_gender { get; set; }
    public string policy_country { get; set; }
    public string policy_currency { get; set; }
    public string patient_surname { get; set; }
    public string patient_forenames { get; set; }

    public string patient_dob { get; set; }
    public string vip_message { get; set; }
    public bool has_copay { get; set; }
    public string co_pay_amount { get; set; }
    public CopayInfo copay_info { get; set; }
    public List<Benefits> benefits { get; set; } 
    public int session_id { get; set; }
    public string session_type { get; set; }
    public string admit_id { get; set; }

}

public class CopayInfo
{

    public bool has_copay { get; set; }
    public double amount { get; set; }

}


public class Benefits
{

    public int id { get; set; }

    public string pool_nr { get; set; }

    public string pool_desc { get; set; }

    public double amount { get; set; }

    public bool claimable { get; set; }
    public string location_id { get; set; }
    public string location_name { get; set; }
    public string sp_id { get; set; }
    public List<groups> groups { get; set; }
    public exchange_location exchange_location { get; set; }

}


public class groups
{

    public string code { get; set; }
    public string name { get; set; }



}

public class exchange_location
{

    public int id { get; set; }
    public string sl_id { get; set; }
    public string sp_id { get; set; }
    public string location_description { get; set; }
    public string group_practice_number { get; set; }
    public string country_code { get; set; }


}

