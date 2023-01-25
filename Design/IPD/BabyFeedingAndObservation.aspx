<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BabyFeedingAndObservation.aspx.cs" Inherits="Design_IPD_BabyFeedingAndObservation" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
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
                <b>Baby Feeding And Observation Chart </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <asp:Label ID="lblMotherID" runat="server" CssClass="ItDoseLblError" style="display: none;" />                           
        </div>
          
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 50%">
                <tr>
                    <td style="text-align:right" class="auto-style1" >
                        Date :&nbsp;
                    </td>
                    <td style="width: 30%;text-align:left">
                        <asp:TextBox ID="txtDate" onchange="bindBabyFeeding()" runat="server" ClientIDMode="Static"></asp:TextBox>
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
                <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveBabyFeeding()" />
                </div>
          </div>
          </div>
        </form>
</body>
</html>
        <script type="text/javascript">
            function BabyFeeding() {
                var dataBabyFeeding = new Array();
                var ObjBabyFeeding = new Object();
                jQuery("#tb_grdBabyFeeding tr").each(function () {
                    var id = jQuery(this).attr("id");

                    var $rowid = jQuery(this).closest("tr");
                    if ((id != "Header") || (id != "undefined") || (id != "")) {
                        if ($rowid.find("#chkSelect").is(':checked') == true) {
                            ObjBabyFeeding.NGTOral = $rowid.find("input[id*=txtNGTOral]").val();
                            ObjBabyFeeding.NGTOnly = $rowid.find("input[id*=txtNGTOnly]").val();
                            ObjBabyFeeding.Infusion = $rowid.find("input[id*=txtInfusion]").val();
                            ObjBabyFeeding.Drugs = $rowid.find("input[id*=txtDrugs]").val();
                            ObjBabyFeeding.Urine = $rowid.find("input[id*=txtUrine]").val();
                            ObjBabyFeeding.Bowel = $rowid.find("input[id*=txtBowel]").val();
                            ObjBabyFeeding.Temp = $rowid.find("input[id*=txtTemp]").val();
                            ObjBabyFeeding.Remarks = $rowid.find("input[id*=txtRemarks]").val();
                            ObjBabyFeeding.Date = $("#txtDate").val();
                            ObjBabyFeeding.Time = $rowid.find("#tdTime_Label").text();
                            ObjBabyFeeding.Shift = $rowid.find("#tdShift").text();
                            ObjBabyFeeding.CreatedBy = $rowid.find("#tdCreatedBy").html();
                            ObjBabyFeeding.ID = $rowid.find("#tdID").html();
                            ObjBabyFeeding.CreatedDate = $rowid.find("#tdCreatedDate").html();
                            dataBabyFeeding.push(ObjBabyFeeding);
                            ObjBabyFeeding = new Object();
                        }
                    }

                });
                return dataBabyFeeding;
            }
            function saveBabyFeeding() {
                var resultbabyfeeding = BabyFeeding();
                var TID = '<%=Request.QueryString["TransactionID"]%>';
                var PID = '<%=Request.QueryString["PatientId"]%>';
                if (resultbabyfeeding != "") {
                    $.ajax({
                        type: "POST",
                        data: JSON.stringify({ babyfeeding: resultbabyfeeding, PID: PID, TID: TID }),
                        url: "BabyFeedingAndObservation.aspx/saveBabyFeeding",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            OutPut = (result.d);
                            if (OutPut == "1") {
                                modelAlert('Record Saved Successfully', function (response) {
                                    bindBabyFeeding();
                                });
                            }
                            else {
                                modelAlert('Error occurred, Please contact administrator');
                                bindBabyFeeding();
                            }
                            $('#btnSave').removeProp('disabled');
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            modelAlert('Error occurred, Please contact administrator');
                            $('#btnSave').removeProp('disabled');
                        }

                    });
                }
                else
                    modelAlert('Please Select At Least One CheckBox');

            }
        </script>
        	 <script id="tb_Item" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdBabyFeeding"
	style="width:920px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">ORAL</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">NGT</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">INFUSION</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">DRUGS</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">URINE</th>	               
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">BOWEL</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">TEMP</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">REMARKS</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Created By</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Select</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none ">Shift</th>	
	        <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none ">DateDiff</th>   
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none ">CreatedDate</th>   
		</tr>
        
		<#       
		var dataLength=Newitem.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Newitem[j];
		#>
           <#if(Newitem[j].Time_Label =="01:00 AM"){#>
        <tr id="trM">
            <td class="GridViewLabItemStyle"  colspan="10">
            <b>Morning</b>
            </td>
        </tr>
            <#}#>

            <#if(Newitem[j].Time_Label =="01:00 PM"){#>
        <tr id="trN">
            <td class="GridViewLabItemStyle"  colspan="10">
            <b>Noon</b>
            </td>
        </tr>
            <#}#>
					<tr id="<#=j+1#>">
                       <td class="GridViewLabItemStyle" id="tdID"  style="width:80px;text-align:left; display:none" ><#=objRow.ID#></td>
					   <td class="GridViewLabItemStyle" id="tdTime_Label"  style="width:80px;text-align:left" ><#=objRow.Time_Label#></td>
                        <td class="GridViewLabItemStyle" id="tdNGTOral"  style="width:90px;text-align:center" >
                          <input type="text" id="txtNGTOral" maxlength="10" style="width:70px" value="<#=objRow.NGTOral#>" 
                              <#if(objRow.IsInfusionEdit =="0"){#>
                              disabled="disabled" 
                              <#} #> > 
                          </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="tdNGTOnly"  style="width:90px;text-align:center" >
                          <input type="text" id="txtNGTOnly" maxlength="10" style="width:70px" value="<#=objRow.NGTOnly#>" 
                              <#if(objRow.IsNGTOnlyEdit =="0"){#>
                              disabled="disabled" 
                              <#} #> > 
                          </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdInfusion"  style="width:90px;text-align:center" >
                         <input type="text" id="txtInfusion" maxlength="10"    style="width:70px" value="<#=objRow.Infusion#>"
                             <#if(objRow.IsNgtOralEdit =="0"){#> 
                       disabled="disabled"   <#}
                              else{#> 
                         <#}
                              #>                            
                             > </input>
					</td>
                      
					<td class="GridViewLabItemStyle" id="tdDrugs" style="width:90px;text-align:right;">
                         <input type="text" id="txtDrugs" maxlength="10"  style="width:70px" value="<#=objRow.Drugs#>"
                             <#if(objRow.IsDrugsEdit =="0"){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
				
					<td class="GridViewLabItemStyle" id="tdUrine"  style="width:80px;text-align:center">
                         <input type="text" id="txtUrine" maxlength="10" style="width:60px" value="<#=objRow.Urine#>"
                             <#if(objRow.IsUrineEdit =="0"){#> 
                        disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdBowel" style="width:90px;text-align:center;">
                        <input type="text" id="txtBowel" maxlength="10"  style="width:70px" value="<#=objRow.Bowel#>"
                             <#if(objRow.IsBowelEdit =="0"){#> 
                       disabled="disabled"  <#} #>                            
                             > </input>
                        </td>
					<td class="GridViewLabItemStyle" id="tdTemp" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtTemp" maxlength="10"  style="width:70px" value="<#=objRow.Temp#>"
                             <#if(objRow.IsTempEdit =="0"){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="tdRemarks" style="width:90px;text-align:center;">
                        
                         <input type="text" id="txtRemarks" maxlength="10"  style="width:70px" value="<#=objRow.Remarks#>"
                             <#if(objRow.IsRemarksEdit =="0"){#> 
                            disabled="disabled" <#} #>                            
                             > </input>
                        </td>
                        <td class="GridViewLabItemStyle" id="tdCreatedBy" style="width:100px;text-align:left"><#=objRow.Name#></td>
					    <td class="GridViewLabItemStyle" id="tdShift"  style="width:80px;text-align:left;display:none" ><#=objRow.Shift#></td>
                        <td class="GridViewLabItemStyle" id="tdDateFiff"  style="width:80px;text-align:left;display:none" ><#=objRow.createdDateDiff#></td>
                        <td class="GridViewLabItemStyle" id="tdCreatedDate"  style="width:80px;text-align:left;display:none" ><#=objRow.CreatedDate#></td>
			            <td class="GridViewLabItemStyle" id="tdSelect"  style="width:80px;text-align:left" ><input type="checkbox" id="chkSelect" 
                    <#if(objRow.IsSelect =="0"){#> 
                        disabled="disabled" <#} #>                            
                   /></td>  
                    </tr> 
 
		<#}#>      
	 </table>    
	</script>	
        <script type="text/javascript">
            $(function () {
                bindBabyFeeding()

                if ($('#lblMotherID').text() == '') {
                    modelConfirmation('Attention !!', 'This patient is not a Baby...!!!', '', 'Close', function () { });
                    $('#btnSave,#btnPrint').hide();
                }
            });

            function bindBabyFeeding() {
                var TransID = '<%=Request.QueryString["TransactionID"]%>';
                jQuery.ajax({
                    type: "POST",
                    url: "BabyFeedingAndObservation.aspx/bindData",
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
            // $("#lblMsg").text('Enter Numeric Value Only');
            //  return false;

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
                        modelAlert('Enter Numeric Value Only');
                    return false;

                }
            }
        }
        else {
            $("#lblMsg").text(' ');
        }


    }
</script>
    
