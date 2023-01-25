<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IntakeOutPutChart.aspx.cs" Inherits="Design_IPD_IntakeOutPutChart" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head runat="server">
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
            
                <b>Intake & Output Chart </b>
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
                    <td><asp:Button ID="btnPrint" runat="server" CssClass="ItDoseButton" Text="Print" OnClick="btnPrint_Click" /></td>
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
                            ObjIntake.Solution = $rowid.find("input[id*=txtSolution]").val();
                            ObjIntake.SolVol = $rowid.find("input[id*=txtSolVol]").val();
                            ObjIntake.NGTOraSpDiet = $rowid.find("input[id*=txtNGTOraSpDiet]").val();
                            ObjIntake.VolNgt = $rowid.find("input[id*=txtVolNgt]").val();
                            ObjIntake.Medication = $rowid.find("input[id*=txtMedication]").val();
                            ObjIntake.VolMedication = $rowid.find("input[id*=txtVolMedication]").val();
                            ObjIntake.UrineVolumn = $rowid.find("input[id*=txtUrineVolumn]").val();
                            ObjIntake.Other = $rowid.find("input[id*=txtOther]").val();
                            ObjIntake.RunningOutPut = $rowid.find("input[id*=txtRunningOutPut]").val();
                            ObjIntake.More_infusion_pumps = $rowid.find("input[id*=txtMore_infusion_pumps]").val();
                            ObjIntake.More_drains = $rowid.find("input[id*=txtMore_drains]").val();
                            ObjIntake.OraSpDiet = $rowid.find("input[id*=txtOraSpDiet]").val();
                            ObjIntake.NGTAspiration = $rowid.find("input[id*=txtNGT_Aspiration]").val();
                            


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
                        url: "IntakeOutPutChart.aspx/saveIntake",
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
	style="width:920px;border-collapse:collapse;">
        <thead>
        <tr>
			<th class="GridViewHeaderStyle" scope="col"  style="width:120px;"></th>
			<th class="GridViewHeaderStyle" scope="col" colspan="7">Intake Chart</th>
			<th class="GridViewHeaderStyle" scope="col" colspan="6">OutPut Chart</th>
            <th class="GridViewHeaderStyle" scope="col"  style="width:80px;"></th>
            <th class="GridViewHeaderStyle" scope="col"  style="width:80px;"></th>
         
			           
		</tr>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; "></th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">IVF Solution</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Vol(ml)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">NGT</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Oral</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Vol(ml)</th>		          
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Medication</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Infusion Pumps</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Vol(ml)</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Urine(ml)</th>	               
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Other</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Other 2</th>	
            	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> Drains</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;"> NGT Aspiration</th>	
            	<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Created By</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none ">Shift</th>	
            		           
		</tr>
            </thead>
		<#       
		var dataLength=Newitem.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Newitem[j];
		#>
					<tr id="<#=j+1#>">
                                      <td class="GridViewLabItemStyle" id="tdSelect"  style="width:80px;text-align:left" ><input type="checkbox" id="chkSelect" 
                    <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                   /></td>              
					<td class="GridViewLabItemStyle" id="tdTime_Label"  style="text-align:left" ><#=objRow.Time_Label#></td>
					<td class="GridViewLabItemStyle" id="tdSolution"  style="width:90px;text-align:center" >
                       
                         <input type="text" id="txtSolution" maxlength="10"    style="width:70px" value="<#=objRow.Solution#>"
                             <#if(objRow.Name !=""){#> 
                       disabled="disabled"   <#}
                              else{#> 
                         <#}
                              #>                            
                             > </input>
                         
					</td>
                        <td class="GridViewLabItemStyle" id="td1" style="width:80px;text-align:center; ">
                        <input type="text" id="txtSolVol" maxlength="4" onpaste="return false" style="width:60px" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.SolVol#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#}  #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdNGTOraSpDiet"  style="width:90px;text-align:center" >
                          <input type="text" id="txtNGTOraSpDiet" maxlength="10" style="width:70px" value="<#=objRow.NGTOraSpDiet#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>


                        <td class="GridViewLabItemStyle" id="tdOraSpDiet"  style="width:90px;text-align:center" >
                          <input type="text" id="txtOraSpDiet" maxlength="10" style="width:70px" value="<#=objRow.OraSpDiet#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>



					<td class="GridViewLabItemStyle" id="tdVolNgt" style="width:80px;text-align:center; ">
                        <input type="text" id="txtVolNgt" maxlength="4" onpaste="return false" style="width:60px" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.VolNgt#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdMedication" style="width:90px;text-align:right;">
                         <input type="text" id="txtMedication" maxlength="10"  style="width:70px" value="<#=objRow.Medication#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="tdMore_infusion_pumps" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtMore_infusion_pumps" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.More_infusion_pumps#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdVolMedication" style="width:80px;text-align:right;">
                         <input type="text" id="txtVolMedication"  onpaste="return false" maxlength="4" onkeypress="return checkForSecondDecimal(this,event)"  style="width:60px" value="<#=objRow.VolMedication#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					
					<td class="GridViewLabItemStyle" id="tdUrineVolumn"  style="width:80px;text-align:center">
                         <input type="text" id="txtUrineVolumn" maxlength="10" style="width:60px" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.UrineVolumn#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdOther" style="width:90px;text-align:center;">
                        <input type="text" id="txtOther" maxlength="10"  style="width:70px" value="<#=objRow.Other#>"
                             <#if(objRow.Name !=""){#> 
                       disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdRunningOutPut" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtRunningOutPut" maxlength="10"  style="width:70px" value="<#=objRow.RunningOutPut#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>


                    	


                        <td class="GridViewLabItemStyle" id="tdMore_drains " style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtMore_drains" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.More_drains #>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
                           <td class="GridViewLabItemStyle" id="tdNGT_Aspiration" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtNGT_Aspiration" maxlength="10"  style="width:70px;text-align:center;" value="<#=objRow.NGT_Aspiration #>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>


                        <td class="GridViewLabItemStyle" id="tdCreatedBy" style="width:100px;text-align:left"><#=objRow.Name#></td>
							<td class="GridViewLabItemStyle" id="tdShift"  style="width:80px;text-align:left;display:none" ><#=objRow.Shift#></td>
			
                    </tr> 
        <#
        if(Newitem[j].Time_Label =="07:00 PM")
    {#>
        <tr id="trTA">
            <td class="GridViewLabItemStyle"><span><b>Morning Sub/TA</b></span></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.MorningSolVol#></b></td>
            <td class="GridViewLabItemStyle"></td>           
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.MorningVolNgt#></b></td>
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter" ><b><#=objRow.TotalMorningMore_infusion_pumps#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.MorningVolMedication#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.MorningUrineVolumn#></b></td>
           
            
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle textCenter"><b><#=objRow.TotalMorningMore_drains#></b></td>
             <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
        </tr>   
        <#}
        #> 
                    
        <#
        if(Newitem[j].Time_Label =="06:00 AM")
    {#>
        <tr class="GridViewLabItemStyle" id="trTB">


            <td class="GridViewLabItemStyle"><span><b>Evening Sub/TB</b></span></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.EveningSolVol#></b></td>
            <td class="GridViewLabItemStyle"></td>           
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.EveningVolNgt#></b></td>
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter" ><b><#=objRow.TotalEveningMore_infusion_pumps#></b></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.EveningVolMedication#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.EveningUrineVolumn#></b></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle textCenter"><b><#=objRow.TotalEveningMore_drains#></b></td>
             <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
        </tr>   
        <#}
        #>    
        <#
        if(Newitem[j].Time_Label =="06:00 AM")
    {#>
        <tr id="tr1">
            <td class="GridViewLabItemStyle"><span><b>Grand T</b></span></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.TotalSolVol#></b></td>
            <td class="GridViewLabItemStyle"></td>           
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.TotalVolNgt#></b></td>
            <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle textCenter" ><b><#=objRow.TotalMore_infusion_pumps#></b></td>
            <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.TotalVolMedication#></b></td>
           <td class="GridViewLabItemStyle textCenter"><b> <#=objRow.TotalUrineVol#></b></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle textCenter"><b><#=objRow.TotalMore_drains#></b></td>
             <td class="GridViewLabItemStyle"></td>
             <td class="GridViewLabItemStyle"></td>
            <td class="GridViewLabItemStyle"></td>
        </tr> 
       <tr id="tr2">
           <td class="GridViewLabItemStyle" scope="col"  style="width:120px;"></td>

			<td class="GridViewLabItemStyle" scope="col" colspan="2"><span><b>Total Intake</b></span></td>
           <td class="GridViewLabItemStyle" scope="col" colspan="5"><b><#=objRow.TotalIntake#></b></td>

			<td class="GridViewLabItemStyle" scope="col" colspan="2"><span><b>Total OutPut </b></span></td>
           <td class="GridViewLabItemStyle" scope="col" colspan="3"><span><b><#=objRow.TotalVolMedication#></b></span></td>

            <td class="GridViewLabItemStyle" scope="col"  style="width:80px;"></td>
            <td class="GridViewLabItemStyle" scope="col"  style="width:80px;"></td>
             <td class="GridViewLabItemStyle" scope="col"  style="width:80px;"></td>

        </tr>
              <tr id="tr3">
           <td class="GridViewLabItemStyle" scope="col"  style="width:120px;"></td>

			<td class="GridViewLabItemStyle" scope="col" colspan="2"><span><b>Daily Balance </b></span></td>
           <td class="GridViewLabItemStyle" scope="col" colspan="5"><b><#=objRow.DailyBalance#></b></td>

			<td class="GridViewLabItemStyle" scope="col" colspan="2"><span><b>Cumulative Balance </b></span></td>
           <td class="GridViewLabItemStyle" scope="col" colspan="3"><span><b><#=objRow.QumulativeBalance#></b></span></td>

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

            function bindIntake() {
                var TransID = '<%=Request.QueryString["TransactionID"]%>';
                jQuery.ajax({
                    type: "POST",
                    url: "IntakeOutPutChart.aspx/bindData",
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
    
