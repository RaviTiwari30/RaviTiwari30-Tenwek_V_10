<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cardiac_IntakeOutPutChart.aspx.cs" Inherits="Design_ip_Cardiac_IntakeOutPutChart" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head id="Head1" runat="server">
    <title></title>
     <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    
    <script type="text/javascript"  src ="../../Scripts/jquery-1.7.1.min.js"></script>
  
  <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
    <style type="text/css">
        .auto-style1 {
            width: 24%;
        }

        .textCenter {
            text-align: center;
        }
    </style>
</head>
<body>
     <script type="text/javascript">
            if ($.browser.msie) {
                $(document).on("keydown", function (e) {
                    var doPrevent;
                    if (e.keyCode == 8) {
                        var d = e.srcElement || e.target;
                        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                            doPrevent = d.readOnly
                                || d.disabled;
                        }
                        else
                            doPrevent = true;
                    }
                    else
                        doPrevent = false;
                    if (doPrevent) {
                        e.preventDefault();
                    }
                });
            }


   </script>
     <script  type="text/javascript">
         function check(e) {
             var keynum
             var keychar
             var numcheck
             // For Internet Explorer  
             if (window.event) {
                 keynum = e.keyCode
             }
                 // For Netscape/Firefox/Opera  
             else if (e.which) {
                 keynum = e.which
             }
             keychar = String.fromCharCode(keynum)

             //List of special characters you want to restrict
             if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                 return false;
             }

             else {
                 return true;
             }
         }
    </script>
    <form id="form1" runat="server">
      <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Intake And OutPut Chart </b>
                <br />
                  <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
          
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 50%">
                <tr>
                    <td style="text-align:right" class="auto-style1" >
                        Date :&nbsp;
                    </td>
                    <td style="width: 30%;text-align:left">
                        <asp:TextBox ID="txtDate" onchange="bindIntake()" runat="server" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </td>
                    <td><asp:Button ID="btnPrint" runat="server" CssClass="ItDoseButton" Text="Print" OnClick="btnPrint_Click" Visible="false" /></td>
                </tr>
            </table>
          
            </div>
          
       
            <div class="POuter_Box_Inventory">
          <div id="ItemOutput" style="max-height: 600px; overflow-x: auto;">
						</div>
                	</div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <input type="button" value="Save" class="ItDoseButton" onclick="saveIntake()" />
                </div>
          </div>
          </div>
        </form>
</body>
</html>
        <script type="text/javascript">
            function Intake() {
                var dataIntake = new Array();
                var ObjIntake = new Object();
                jQuery("#tb_grdIntake tr").each(function () {
                    var id = jQuery(this).attr("id");

                    var $rowid = jQuery(this).closest("tr");
                    if ((id != "Header") || (id != "trTA") || (id != "trTB") || (id != "undefined") || (id != "")) {
                        if ($rowid.find("#chkSelect").is(':checked') == true) {
                            ObjIntake.Id = $rowid.find("input[id*=txtId]").val();
                            ObjIntake.MIVF = $rowid.find("input[id*=txtMIVF]").val();
                            ObjIntake.Hourlydrips = $rowid.find("input[id*=txtHourlydrips]").val();
                            ObjIntake.BloodBolus = $rowid.find("input[id*=txtBloodBolus]").val();
                            ObjIntake.POintake = $rowid.find("input[id*=txtPOintake]").val();
                            ObjIntake.POintake1 = $rowid.find("input[id*=txtPOintake1]").val();
                            ObjIntake.HourTotal = $rowid.find("input[id*=txtHourTotal]").val();
                            ObjIntake.Cimulative = $rowid.find("input[id*=txtCimulative]").val();
                            ObjIntake.CT1Level = $rowid.find("input[id*=txtCT1Level]").val();
                            ObjIntake.CT2Level = $rowid.find("input[id*=txtCT2Level]").val();
                            ObjIntake.CToutput = $rowid.find("input[id*=txtCToutput]").val();
                            ObjIntake.Urine = $rowid.find("input[id*=txtUrine]").val();
                            ObjIntake.Stool = $rowid.find("input[id*=txtStool]").val();
                            ObjIntake.Vomiting = $rowid.find("input[id*=txtVomiting]").val();
                            ObjIntake.Hourstotal = $rowid.find("input[id*=txtHourstotal]").val();
                            ObjIntake.Cumulative = $rowid.find("input[id*=txtCumulative1]").val();



                            ObjIntake.Date = $("#txtDate").val();
                            ObjIntake.Time = $rowid.find("#tdTime_Label").text();
                            ObjIntake.Shift = $rowid.find("#tdShift").text();
                            ObjIntake.CreatedBy = $rowid.find("#tdCreatedBy").html();
                            dataIntake.push(ObjIntake);
                            ObjIntake = new Object();
                        }
                    }

                });
                return dataIntake;
            }
            function saveIntake() {
                var resultIntake = Intake();
                var TID = '<%=Request.QueryString["TransactionID"]%>';
                var PID = '<%=Request.QueryString["PatientId"]%>';
                if (resultIntake != "") {
                    $.ajax({
                        type: "POST",
                        data: JSON.stringify({ Intake: resultIntake, PID: PID, TID: TID }),
                        url: "Cardiac_IntakeOutPutChart.aspx/saveIntake",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            IntakeOutPut = (result.d);
                            if (IntakeOutPut == "1") {
                                $("#lblMsg").text('Record Saved Successfully');
                                bindIntake();
                            }
                            else {
                                $("#lblMsg").text('Error occurred, Please contact administrator');
                                bindIntake();
                            }
                            $('#btnSave').removeProp('disabled');
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                            $('#btnSave').removeProp('disabled');
                        }

                    });
                }
                else
                    $("#lblMsg").text('Please Select At Least One CheckBox');

            }
        </script>
        	 <script id="tb_Item" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdIntake"
	style="width:1200px;border-collapse:collapse;">
        <tr>
			<th class="GridViewHeaderStyle" scope="col"  style="width:120px;"></th>
			<th class="GridViewHeaderStyle" scope="col" colspan="7">Intake Chart</th>
			<th class="GridViewHeaderStyle" scope="col" colspan="8">OutPut Chart</th>
            <th class="GridViewHeaderStyle" scope="col"  style="width:80px;"></th>
            <th class="GridViewHeaderStyle" scope="col"  style="width:80px;"></th>
         
			           
		</tr>
		<tr id="Header">
			
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">MIVF</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Hourly drips</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Blood/Bolus</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">PO intake</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">PO intake1</th>		          
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Hour Total</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Cimulative</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">CT 1 Level</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">CT 2 Level</th>	               
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">CT output</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Urine</th>	
            	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Stool</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Vomiting</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Hours total</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Cumulative</th>	
            	<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Created By</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none ">Shift</th>	
            	<th class="GridViewHeaderStyle" scope="col" style="width:80px; "></th>		           
		</tr>
		<#       
		var dataLength=Newitem.length;
		window.status="Total Records Found :"+ dataLength;
        var totalmivf=0,totalhourlydrips=0,totalbloodbolus=0,totalpointake=0,totalpointake1=0,totalct1level=0,totalct2level=0,totalctoutput=0,totalurine=0,totalstool=0;
        var mtotalmivf=0,mtotalhourlydrips=0,mtotalbloodbolus=0,mtotalpointake=0,mtotalpointake1=0,mtotalct1level=0,mtotalct2level=0,mtotalctoutput=0,mtotalurine=0,mtotalstool=0;
		
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Newitem[j];
            if(objRow.MIVF!=null&&objRow.MIVF!="")
            {
            totalmivf+=parseInt(objRow.MIVF);
            }
            if(objRow.Hourlydrips!=null&&objRow.Hourlydrips!="")
            {
            totalhourlydrips+=parseInt(objRow.Hourlydrips);
            }
            if(objRow.BloodBolus!=null&&objRow.BloodBolus!="")
            {
            totalbloodbolus+=parseInt(objRow.BloodBolus);
            }
            if(objRow.POintake!=null&&objRow.POintake!="")
            {
            totalpointake+=parseInt(objRow.POintake);
            }
            if(objRow.POintake1!=null&&objRow.POintake1!="")
            {
            totalpointake1+=parseInt(objRow.POintake1);
            }
            if(objRow.CT1Level!=null&&objRow.CT1Level!="")
            {
            totalct1level+=parseInt(objRow.CT1Level);
            }
            if(objRow.CT2Level!=null&&objRow.CT2Level!="")
            {
            totalct2level+=parseInt(objRow.CT2Level);
            }
            if(objRow.CToutput!=null&&objRow.CToutput!="")
            {
            totalctoutput+=parseInt(objRow.CToutput);
            }
            if(objRow.Urine!=null&&objRow.Urine!="")
            {
            totalurine+=parseInt(objRow.Urine);
            }
            if(objRow.Stool!=null&&objRow.Stool!="")
            {
            totalstool+=parseInt(objRow.Stool);
            }
		#>
					<tr id="<#=j+1#>">
                                                
					<td class="GridViewLabItemStyle" id="tdTime_Label"  style="text-align:left" ><#=objRow.Time1#></td>
					<td class="GridViewLabItemStyle" id="tdSolution"  style="width:90px;text-align:center" >
                       <input id="txtId" type="hidden" value="<#=objRow.CId#>" />  
                         <input type="text" id="txtMIVF" maxlength="10"    style="width:70px" value="<#=objRow.MIVF#>" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"
                             <#if(objRow.Name !=""){#> 
                       disabled="disabled"   <#}
                              else{#> 
                         <#}
                              #>                            
                             > </input>
                         
					</td>
                        <td class="GridViewLabItemStyle" id="td1" style="width:80px;text-align:center; ">
                        <input type="text" id="txtHourlydrips" maxlength="4" onpaste="return false" style="width:60px" onkeypress="return isAlphaNumeric(event,this.value);"
 value="<#=objRow.Hourlydrips#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#}  #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdNGTOraSpDiet"  style="width:90px;text-align:center" >
                          <input type="text" id="txtBloodBolus" maxlength="10" style="width:70px" value="<#=objRow.BloodBolus#>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>


                        <td class="GridViewLabItemStyle" id="tdOraSpDiet"  style="width:90px;text-align:center" >
                          <input type="text" id="txtPOintake" maxlength="10" style="width:70px" value="<#=objRow.POintake#>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>



					<td class="GridViewLabItemStyle" id="tdVolNgt" style="width:80px;text-align:center; ">
                        <input type="text" id="txtPOintake1" maxlength="4" onpaste="return false" value="<#=objRow.POintake1#>" style="width:60px" onkeypress="return isAlphaNumeric(event,this.value);"
 value="<#=objRow.POintake#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdMedication" style="width:90px;text-align:right;">
                         <input type="text" id="txtHourTotal" maxlength="10"  style="width:70px" value="<#=objRow.HourTotal #>"  onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="tdMore_infusion_pumps" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtCimulative" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.Cimulative #>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdVolMedication" style="width:80px;text-align:right;">
                         <input type="text" id="txtCT1Level"  onpaste="return false" maxlength="4" onkeypress="return isAlphaNumeric(event,this.value);"
  style="width:60px" value="<#=objRow.CT1Level#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					
					<td class="GridViewLabItemStyle" id="tdUrineVolumn"  style="width:80px;text-align:center">
                         <input type="text" id="txtCT2Level" maxlength="10" style="width:60px"  onkeypress="return isAlphaNumeric(event,this.value);"
 value="<#=objRow.CT2Level#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdOther" style="width:90px;text-align:center;">
                        <input type="text" id="txtCToutput" maxlength="10"  style="width:70px" value="<#=objRow.CToutput#>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                       disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdRunningOutPut" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtUrine" maxlength="10"  style="width:70px" value="<#=objRow.Urine#>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>


                    	


                        <td class="GridViewLabItemStyle" id="tdMore_drains " style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtStool" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.Stool #>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
                           <td class="GridViewLabItemStyle" id="tdNGT_Aspiration" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtVomiting" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.Vomiting #>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="td3" style="width:100px;text-align:left">

                             <input type="text" id="txtHourstotal" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.Hourstotal #>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>

                        </td>
                        <td class="GridViewLabItemStyle" id="td2" style="width:100px;text-align:left">
                                   <input type="text" id="txtCumulative1" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.Cumulative #>" onkeypress="return isAlphaNumeric(event,this.value);"

                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="tdCreatedBy" style="width:100px;text-align:left"><#=objRow.CreatedBy1#></td>
							<td class="GridViewLabItemStyle" id="tdShift"  style="width:80px;text-align:left;display:none" ><#=objRow.CreatedBy1#></td>
			  <td class="GridViewLabItemStyle" id="tdSelect"  style="width:80px;text-align:left" ><input type="checkbox" id="chkSelect" 
                    <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                   /></td>  
                    </tr> 
        <#
            
        if(Newitem[j].Time1 =="07:00 PM")
    {
            mtotalmivf=totalmivf;
            mtotalhourlydrips=totalhourlydrips;
            mtotalbloodbolus=totalbloodbolus;
            mtotalpointake=totalpointake;
            mtotalpointake1=totalpointake1;
            mtotalct1level=totalct1level;
            mtotalct2level=totalct2level;
            mtotalctoutput=totalctoutput;
            mtotalurine=totalurine;
            mtotalstool=totalstool;
            #>
        <tr style="background-color:#0094ff;color:white;" id="trTA">
            <td class="GridViewLabItemStyle"><span><b>Morning Sub/TA</b></span></td>
            <td class="GridViewLabItemStyle"><#=totalmivf#></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=totalhourlydrips#></b></td>
            <td class="GridViewLabItemStyle"><#=totalbloodbolus#></td>           
            <td class="GridViewLabItemStyle"><#=totalpointake#></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=totalpointake1#></b></td>
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter" ><b></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=totalct1level#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=totalct2level#></b></td>
           
            
            <td class="GridViewLabItemStyle"><#=totalctoutput#></td>
            <td class="GridViewLabItemStyle"><#=totalurine#></td>
            <td class="GridViewLabItemStyle textCenter"><b><#=totalstool#></b></td>
             <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
        </tr>   
        <#}
        #> 
                    
        <#
        if(Newitem[j].Time1 =="06:00 AM")
    {#>
        <tr style="background-color:#0094ff;color:white;" class="GridViewLabItemStyle" id="trTB">


            <td class="GridViewLabItemStyle"><span><b>Evening Sub/TB</b></span></td>
            <td class="GridViewLabItemStyle"><#=(totalmivf-mtotalmivf)#></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=(totalhourlydrips-mtotalhourlydrips)#></b></td>
            <td class="GridViewLabItemStyle"><#=(totalbloodbolus-mtotalbloodbolus)#></td>           
            <td class="GridViewLabItemStyle"><#=(totalpointake-mtotalpointake)#></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=(totalpointake1-mtotalpointake1)#></b></td>
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter" ><b></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=(totalct1level-mtotalct1level)#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=(totalct2level-mtotalct2level)#></b></td>
           
            
            <td class="GridViewLabItemStyle"><#=(totalctoutput-mtotalctoutput)#></td>
            <td class="GridViewLabItemStyle"><#=(totalurine-mtotalurine)#></td>
            <td class="GridViewLabItemStyle textCenter"><b><#=(totalstool-mtotalstool)#></b></td>
             <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
       
        </tr>   
        <#}
        #>    
        <#
        if(Newitem[j].Time1 =="06:00 AM")
    {#>
        <tr id="tr1" style="background-color:#0094ff;color:white;">
            <td class="GridViewLabItemStyle"><span><b>Grand T</b></span></td>
            <td class="GridViewLabItemStyle"><#=totalmivf#></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=totalhourlydrips#></b></td>
            <td class="GridViewLabItemStyle"><#=totalbloodbolus#></td>           
            <td class="GridViewLabItemStyle"><#=totalpointake#></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=totalpointake1#></b></td>
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter" ><b></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=totalct1level#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=totalct2level#></b></td>
           
            
            <td class="GridViewLabItemStyle"><#=totalctoutput#></td>
            <td class="GridViewLabItemStyle"><#=totalurine#></td>
            <td class="GridViewLabItemStyle textCenter"><b><#=totalstool#></b></td>
             <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
        </tr> 
       <tr id="tr2">
           <td class="GridViewLabItemStyle" scope="col"  style="width:120px;"></td>

			<td class="GridViewLabItemStyle" scope="col" colspan="2"><span><b>Total Intake</b></span></td>
           <td class="GridViewLabItemStyle" scope="col" colspan="5"><b><#=totalmivf+totalhourlydrips+totalbloodbolus+totalpointake+totalpointake1#></b></td>

			<td class="GridViewLabItemStyle" scope="col" colspan="2"><span><b>Total OutPut </b></span></td>
           <td class="GridViewLabItemStyle" scope="col" colspan="3"><span><b><#=totalct1level+totalct2level+totalctoutput+totalurine+totalstool#></b></span></td>

            <td class="GridViewLabItemStyle" scope="col"  style="width:80px;"></td>
            <td class="GridViewLabItemStyle" scope="col"  style="width:80px;"></td>
             <td class="GridViewLabItemStyle" scope="col"  style="width:80px;"></td>

        </tr>    
        <#}
        #> 
         
		<#}        
		#>      
	 </table>    
	</script>	
        <script type="text/javascript">
            $(function () {
                bindIntake()
            });
            function isAlphaNumeric(e) {
                var k;
                document.all ? k = e.keycode : k = e.which;
                return ((k > 47 && k < 58) || (k > 64 && k < 91) || (k > 96 && k < 123) || k == 0);

            };
            function bindIntake() {
                var TransID = '<%=Request.QueryString["TransactionID"]%>';
                jQuery.ajax({
                    type: "POST",
                    url: "Cardiac_IntakeOutPutChart.aspx/bindData",
                    data: '{TransID:"' + TransID + '",Date:"' + $("#txtDate").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    success: function (response) {
                        Newitem = jQuery.parseJSON(response.d);
                        if (Newitem != null) {
                            var output = jQuery('#tb_Item').parseTemplate(Newitem);
                            jQuery('#ItemOutput').html(output);
                            jQuery('#ItemOutput').show();
                            //  $("#lblMsg").text(' ');
                        }

                        else {
                            jQuery('#ItemOutput').hide();
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
            }
        </script>
<script type="text/javascript">
    function checkForSecondDecimal(sender, e) {
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            $("#lblMsg").text('Enter Numeric Value Only');
            return false;

        }
        else {
            $("#lblMsg").text(' ');
        }
        strLen = sender.value.length;
        strVal = sender.value;
        hasDec = false;
        e = (e) ? e : (window.event) ? event : null;
        if (e) {
            var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
            if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                for (var i = 0; i < strLen; i++) {
                    hasDec = (strVal.charAt(i) == '.');
                    if (hasDec)
                        $("#lblMsg").text('Enter Numeric Value Only');
                    return false;

                }
            }
        }
        else {
            $("#lblMsg").text(' ');
        }


    }
</script>
    
