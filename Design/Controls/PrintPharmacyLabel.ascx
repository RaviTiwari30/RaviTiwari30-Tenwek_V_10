<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrintPharmacyLabel.ascx.cs" Inherits="Design_Controls_PrintPharmacyLabel" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<link rel="stylesheet" href="../../Styles/jquery-ui.css" />
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>--%>
<%--<script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>--%>
<%--<script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
<script src="../../Scripts/json2.js" type="text/javascript"></script>--%>
<script type="text/javascript" src="../../Scripts/searchableDroplist.js"></script>
<script type="text/ecmascript" src="../../Scripts/Message.js"></script>
<script type="text/javascript">
    function PrintLabel() {
        var chk = 1; var LabelString = ""; var ItemName = ""; var Dose = ""; var Times = ""; var fullinstructions = ""; var Duration = ""; var SideEffect = "";
        var Meals = ""; var PName = ""; var MRNo = ""; var LedgerTransactionNo = "";
        $('#tb_LabelPrintItems tr').each(function () {
            var id = $(this).attr("id");
            var $rowid = $(this).closest("tr");
            if (id != 'LabelPrintHeader') {
                if ($(this).find("#chkLabelItem").is(":checked")) {
                    var PQty = $rowid.find("#ddlPrintQty option:selected").val();
                    chk += 1;
                    for (i = 0; i < PQty; i++) {
                        chk += 1;
                        ItemName = $rowid.find("#tdItemName_label").html();
                        if ($rowid.find("#txtdose").val() != "") {
                            Dose = $rowid.find("#txtdose").val();
                        }
                        if ($rowid.find("#txtdose").val() == "") {
                            Dose = ($.trim($rowid.find("#ddlDose option:selected").val()));
                        }
                        if ($rowid.find("#txtTime").val() != "") {
                            Times = $rowid.find("#txtTime").val();
                        }
                        if ($rowid.find("#txtTime").val() == "") {
                            Times = ($.trim($rowid.find("#ddlTime option:selected").val()));
                        }
                        fullinstructions += Dose;
                        fullinstructions += ", ";
                        fullinstructions += Times;
                        fullinstructions += " For ";
                        if ($rowid.find("#txtDuration").val() != "") {
                            Duration = $rowid.find("#txtDuration").val();
                        }
                        if ($rowid.find("#txtDuration").val() == "") {
                            Duration = ($.trim($rowid.find("#ddlDuration option:selected").val()));
                        }
                        //fullinstructions += Duration;
                        if ($rowid.find("#txtSideEffect").val() != "") {
                            SideEffect = $rowid.find("#txtSideEffect").val();
                        }
                        if ($rowid.find("#txtSideEffect").val() == "") {
                            SideEffect = ($.trim($rowid.find("#ddlSideEffect option:selected").val()));
                        }
                        if ($rowid.find("#txtMeal").val() != "") {
                            SideEffect = $rowid.find("#txtMeal").val();
                        }
                        if ($rowid.find("#txtMeal").val() == "") {
                            SideEffect = ($.trim($rowid.find("#ddlMeal option:selected").val()));
                        }
                        PName = $rowid.find("#tdPname_label").html();
                        MRNo = $rowid.find("#tdMRNo").html();
                        LedgerTransactionNo = $rowid.find("#tdLedgerTransactionNo").html();
                        LabelString += "<%=Resources.Resource.ClientName%>" + "#" + "<%=Resources.Resource.ClientAddress%>" + "#" + "<%=Resources.Resource.ClientTelophone%>" + "#" + PName + "#" + MRNo + "#" + ItemName + "#" + Dose + "#" + Times + "#" + Duration + "#" + SideEffect + "#" + Meals + "#" + MedExpiry;
                        }
                    }
                }

		});
            if (chk == "1") {
                $("#spnmsg").text('Please Select No. Of Print');
                // $find("mpePrint").show();
                showLabelPrintPopup();
              
                return;
            }
            if (chk > 1) {
                WriteToFile(LabelString.toString());
                // $find("mpePrint").hide();
                closeLabelPrintPopup();
            }
        }



    function SavePrintLabel() {
        var chk = 1; var LabelString = ""; var ItemName = ""; var Dose = ""; var Times = ""; var fullinstructions = ""; var Duration = ""; var SideEffect = "";
        var Meals = ""; var PName = ""; var MRNo = ""; var LedgerTransactionNo = "";

        var dataPrint = new Array();
        var objPrints = new Object();
        var NewObj = new Object();
        $('#tb_LabelPrintItems tr').each(function () {
            var id = $(this).attr("id");
            var $rowid = $(this).closest("tr");
            if (id != 'LabelPrintHeader') { 
                if ($(this).find("#chkLabelItem").is(":checked")) {
                    var PQty = $rowid.find("#ddlPrintQty option:selected").val();
                    chk += 1;
                    for (i = 0; i < PQty; i++) {
                        chk += 1;
                        ItemName = $rowid.find("#tdItemName_label").html();
                        if ($rowid.find("#txtDoses").val() != "") {
                            Dose = $rowid.find("#txtDoses").val();
                        }
                       /* if ($rowid.find("#txtdose").val() == "") {
                            Dose = ($.trim($rowid.find("#ddlDose option:selected").text()));
                        }*/
                        if ($rowid.find("#txtTime").val() != "") {
                            Times = $rowid.find("#txtTime").val();
                        }
                        if ($rowid.find("#txtTime").val() == "") {
                            Times = ($.trim($rowid.find("#ddlTime option:selected").text()));
                        }
                        
                        if ($rowid.find("#txtDuration").val() != "") {
                            Duration = $rowid.find("#txtDuration").val();
                        }
                        if ($rowid.find("#txtDuration").val() == "") {
                            Duration = ($.trim($rowid.find("#ddlDuration option:selected").text()));
                        }
                        //fullinstructions += Duration;
                        if ($rowid.find("#txtSideEffect").val() != "") {
                            SideEffect = $rowid.find("#txtSideEffect").val();
                        }
                        if ($rowid.find("#txtSideEffect").val() == "") {
                            SideEffect = ($.trim($rowid.find("#ddlSideEffect option:selected").text()));
                        }
                        if ($rowid.find("#txtMeal").val() != "") {
                            Meals = $rowid.find("#txtMeal").val();
                        }
                        if ($rowid.find("#txtMeal").val() == "") {
                            Meals = ($.trim($rowid.find("#ddlMeal option:selected").text()));
                        }
                        PName = $rowid.find("#tdPname_label").html();
                        MRNo = $rowid.find("#tdMRNo").html();
                        Remarks= $rowid.find("#tdRemarks").text();
                         
                        NewObj.PName = PName;
                        NewObj.MRNo = MRNo;
                        NewObj.SideEffect = SideEffect;
                        NewObj.Duration = Duration;
                        NewObj.Times = Times;
                        NewObj.Dose = Dose;
                        NewObj.ItemName = ItemName;
                        NewObj.ItemDispance = $rowid.find("#tdQuantity").text();
                        NewObj.ItemID = $rowid.find("#tdItemID").text();
                        NewObj.NoOfPrint = PQty,
                        NewObj.Remarks = Remarks
                        NewObj.LedgerTransactionNo = $rowid.find("#tdLedgerTransactionNo").text();
                        dataPrint.push(NewObj); 
                        NewObj = new Object();
                         
                    }
                } 
            }

         });
        if (chk == "1") {
            $("#spnmsg").text('Please Select To Print');
            // $find("mpePrint").show();
            showLabelPrintPopup();

            return;
        }
        if (chk > 1) {
            $.ajax({
                url: "../Store/Services/WebService.asmx/LabelToPrint",
                data: JSON.stringify({ data: dataPrint }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1")
                        window.open('../common/Commonreport.aspx');
                },
                error: function (xhr, status) {

                    modelAlert("Error occurred, Please contact administrator");
                }
            });
        }

    }












        function WriteToFile(data) {
            try { window.location = 'barcode://?cmd=' + data + '&test=1&source=Barcode_Source_Pharmacy'; }
            catch (e) { alert('Error'); }
        }
        function BindIPDPopUp(IndentNo) {
            $.ajax({
                url: "../Store/Services/WebService.asmx/BindIPDItemForLabelPrint",
                data: '{IndentNo:"' + IndentNo + '"}',
                type: "POST",
                contentType: "application/json;charset=UTF-8",
                dataType: "json",
                success: function (response) {
                    ItemList = jQuery.parseJSON(response.d);
                    if (ItemList != null) {
                        var output = $('#tb_LabelPrint').parseTemplate(ItemList);
                        $('#ItemOutputLabel').html(output);
                        $('#ItemOutputLabel').show();
                        SelectedLabelDropDown(ItemList);
                    }
                    else {
                        $('#ItemOutputLabel').html('');
                        $('#ItemOutputLabel').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "spnmsg");
                }
            });
        }

        function BindOPDPopUp(LedgerTnxID) {

            $.ajax({
                url: "../Store/Services/WebService.asmx/BindItemForLabelPrint",
                data: '{LedgerTnxID:"' + LedgerTnxID + '"}',
                type: "POST",
                contentType: "application/json;charset=UTF-8",
                dataType: "json",
                success: function (response) {
                    ItemList = jQuery.parseJSON(response.d);
                    if (ItemList != null) {
                        var output = $('#tb_LabelPrint').parseTemplate(ItemList);
                        $('#ItemOutputLabel').html(output);
                        $('#ItemOutputLabel').show();
                        SelectedLabelDropDown(ItemList);
                    }
                    else {
                        $('#ItemOutputLabel').html('');
                        $('#ItemOutputLabel').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "spnmsg");
                }
            });
        }

        //DEV
        var SelectedLabelDropDown = function (ItemList) {
            $('#tb_LabelPrintItems tr').each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != 'LabelPrintHeader') {
                    var ItemID = $rowid.find("#tdItemID").text();
                    // alert(ItemID);
                    var SelectedItemDetails = ItemList.filter(function (i) { return i.ItemID == ItemID });
                    $rowid.find("#txtDoses").val(SelectedItemDetails[0].Dose);
                    $rowid.find("#ddlDuration").val(SelectedItemDetails[0].DurationVal);
                    $rowid.find("#ddlTime").val(SelectedItemDetails[0].IntervalId);
                }
            });
        }





        function ckhall() {
            if ($("#chkheader").attr('checked')) {
                $("#tb_LabelPrintItems :checkbox").attr('checked', 'checked');
            }
            else {
                $("#tb_LabelPrintItems :checkbox").attr('checked', false);
            }

		}
		function ResetDropDownDose() {
			$('#tb_LabelPrintItems tr').each(function () {
				var id = $(this).attr("id");
				var $rowid = $(this).closest("tr");
				if (id != 'LabelPrintHeader') {
					if ($rowid.find("#txtdose").val() != "") {
						$rowid.find("#txtdose").show("slow");
						$rowid.find("#<%=ddlDose.ClientID%>").find('option[value=0]').attr('selected', true);
					}
				}
			});
		}
		function ResetTextBoxDose() {
			$('#tb_LabelPrintItems tr').each(function () {
				var id = $(this).attr("id");
				var $rowid = $(this).closest("tr");
				if (id != 'LabelPrintHeader') {
					if ($rowid.find("#<%=ddlDose.ClientID%> option:selected").val() != "0") {
						 $rowid.find("#txtdose").val('');
					 }
				 }
			 });
		 }
		 function ResetDropDownTime() {
			 $('#tb_LabelPrintItems tr').each(function () {
				 var id = $(this).attr("id");
				 var $rowid = $(this).closest("tr");
				 if (id != 'LabelPrintHeader') {
					 if ($rowid.find("#txtTime").val() != "") {
						 $rowid.find("#txtTime").show("slow");
						 $rowid.find("#<%=ddlTime.ClientID%>").find('option[value=0]').attr('selected', true);
					 }
				 }
			 });
		 }
		 function ResetTextBoxTime(id) {
			 $('#tb_LabelPrintItems tr').each(function () {
				 var id = $(this).attr("id");
				 var $rowid = $(this).closest("tr");
				 if (id != 'LabelPrintHeader') {
					 if ($rowid.find("#<%=ddlTime.ClientID%> option:selected").val() != "0") {
						 $rowid.find("#txtTime").val('');
					 }
				 }
			 });
		 }
		 function ResetDropDownDuration() {
			 $('#tb_LabelPrintItems tr').each(function () {
				 var id = $(this).attr("id");
				 var $rowid = $(this).closest("tr");
				 if (id != 'LabelPrintHeader') {
					 if ($rowid.find("#txtDuration").val() != "") {
						 $rowid.find("#txtDuration").show("slow");
						 $rowid.find("#<%=ddlDuration.ClientID%>").find('option[value=0]').attr('selected', true);
					 }
				 }
			 });
		 }
		 function ResetTextBoxDuration(id) {
			 $('#tb_LabelPrintItems tr').each(function () {
				 var id = $(this).attr("id");
				 var $rowid = $(this).closest("tr");
				 if (id != 'LabelPrintHeader') {
					 if ($rowid.find("#<%=ddlDuration.ClientID%> option:selected").val() != "0") {
						$rowid.find("#txtDuration").val('');
					}
				}
			});
		 }
	function ResetDropDownSideEffect() {
		$('#tb_LabelPrintItems tr').each(function () {
			var id = $(this).attr("id");
			var $rowid = $(this).closest("tr");
			if (id != 'LabelPrintHeader') {
				if ($rowid.find("#txtSideEffect").val() != "") {
					$rowid.find("#txtSideEffect").show("slow");
					$rowid.find("#<%=ddlSideEffect.ClientID%>").find('option[value=0]').attr('selected', true);
				}
			}
		});
	}
	function ResetTextBoxSideEffect(id) {
		$('#tb_LabelPrintItems tr').each(function () {
			var id = $(this).attr("id");
			var $rowid = $(this).closest("tr");
			if (id != 'LabelPrintHeader') {
				if ($rowid.find("#<%=ddlSideEffect.ClientID%> option:selected").val() != "0") {
					$rowid.find("#txtSideEffect").val('');
					 }
				 }
			 });
	}
	function ResetDropDownMeal() {
		$('#tb_LabelPrintItems tr').each(function () {
			var id = $(this).attr("id");
			var $rowid = $(this).closest("tr");
			if (id != 'LabelPrintHeader') {
				if ($rowid.find("#txtMeal").val() != "") {
					$rowid.find("#txtMeal").show("slow");
					$rowid.find("#<%=ddlMeal.ClientID%>").find('option[value=0]').attr('selected', true);
				}
			}
		});
	}
	function ResetTextBoxMeal(id) {
		$('#tb_LabelPrintItems tr').each(function () {
			var id = $(this).attr("id");
			var $rowid = $(this).closest("tr");
			if (id != 'LabelPrintHeader') {
				if ($rowid.find("#<%=ddlMeal.ClientID%> option:selected").val() != "0") {
					$rowid.find("#txtMeal").val('');
				}
			}
		});
    }
    function closeDetail() {
      //  $find("mpePrint").hide();
        closeLabelPrintPopup();
        $("#tb_LabelPrintItems tr:not(#LabelPrintHeader)").remove();
    }
    function pageLoad(sender, args) {
        if (!args.get_isPartialLoad()) {
            $addHandler(document, "keydown", onKeyDown);
        }
    }
    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            if ($find('dvLabelPrint')) {
              //  $find('mpePrint').hide();
                closeLabelPrintPopup();
                $("#tb_LabelPrintItems tr:not(#LabelPrintHeader)").remove();
            }
        }
    }

    var closeLabelPrintPopup = function () {
        $('#dvLabelPrint').closeModel();
        if (Number($("#IsPharmacyIssue").text()) == 1)
            windowsreload();
    }
    var showLabelPrintPopup = function () {
        $('#dvLabelPrint').showModel();
    }
</script>
  
    <div id="dvLabelPrint" class="modal fade">
            <div class="modal-dialog">
                <div style="min-width:250px" class="modal-content">
                    <div class="modal-header"><h4 style="color:red" class="modal-title"></h4> 
                     <span id="spnmsg" class="ItDoseLblError" ></span>
                          <button type="button" class="close" onclick="closeLabelPrintPopup()" aria-hidden="true">×</button>
                            <h4 class="modal-title"><span id="spnHeaderLabel">Print Label</span> </h4>

                    </div>
                    <div style="text-align: center;margin-left: 20px;margin-right: 20px;" class="modal-body">
                       <div id="ItemOutputLabel" style="max-height:750px; overflow-x: auto;">
                     </div>
                        </div>
                   <div style="text-align:center" class="modal-footer">
                      	<input type="button" value="Print" class="save" id="btnPrintLabel" onclick="SavePrintLabel()" />
                        <input id="btnCancel" class="save"  type="button" value="Cancel" onclick="closeLabelPrintPopup()" />
                       <span id="IsPharmacyIssue" style="display:none;" >0</span>
                   </div>
                </div>
            </div>
        </div>
		<script id="tb_LabelPrint" type="text/html">
			<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_LabelPrintItems"
				style="border-collapse: collapse;">
				<tr id="LabelPrintHeader">
					<th class="GridViewHeaderStyle" scope="col" style="width: 10px;"><input id="chkheader" type="checkbox"  onclick='ckhall();' /></th>
					<th class="GridViewHeaderStyle" scope="col" style="width: 10px;display:none"></th>
					<th class="GridViewHeaderStyle" scope="col" style="width: 100px;" >No. Of Print</th>
					<th class="GridViewHeaderStyle" scope="col" style="width:280px;">Item Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:170px;">IssuedDateTime</th>
					<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Dose</th>
					<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Times</th>
					<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Duration</th>
					<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Caution</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">Meal</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">Remarks</th>
					<th class="GridViewHeaderStyle" scope="col" style="width: 80px; display: none;">PName</th>
					<th class="GridViewHeaderStyle" scope="col" style="width: 80px; display: none;">MRNo</th>
                    <th class="GridViewHeaderStyle" scope="col" style="display: none;">ItemID</th>
                     <th class="GridViewHeaderStyle" scope="col" style="display: none;">LEDGERTNXnO</th>
				</tr>
				<#       
		var dataLabelLength=ItemList.length;
		var objLabelRow;   
		for(var j=0;j<dataLabelLength;j++)
		{       
		objLabelRow = ItemList[j];
		#>
					<tr id="<#=j+1#>"> 
						 <td class="GridViewLabItemStyle" style="width:10px;display:none" id="tdID"><#=j+1#></td>                           
					<td class="GridViewLabItemStyle" id="td1" style="width:10px;"><input type="checkbox" id="chkLabelItem"></td>
					<td class="GridViewLabItemStyle" id="td2"  style="text-align:left;width: 10px;" ><select id="ddlPrintQty"><option>1</option><option>2</option></select></td>
					<td class="GridViewLabItemStyle" id="tdItemName_label"  style="text-align:center; width:280px" ><#=objLabelRow.TypeName#></td>
                    <td class="GridViewLabItemStyle" id="td3"  style="text-align:center; width:170px" ><#=objLabelRow.IssueDateTime#></td>
					<td class="GridViewLabItemStyle" id="tdDose" style="text-align:center;width:80px;">
						<input type="text" id="txtdose" maxlength="30" style="width:100px;display:none" class="nameclass" onkeypress="ResetDropDownDose(); ">
						  <asp:DropDownList ID="ddlDose" ClientIDMode="Static" runat="server" Width="100px" onchange="ResetTextBoxDose();" Visible="false"></asp:DropDownList>
                        <input type="text" id="txtDoses" style="width:80px" tabindex="6"  class="ItDoseTextinputNum"   onlynumber="5" decimalplace="2" max-value="999"  />  
					</td>
					<td class="GridViewLabItemStyle" id="tdTime" style="text-align:center;width:80px;"><input type="text" id="txtTime" maxlength="30" style="width:100px;display:none" onkeypress="ResetDropDownTime();" >
						<asp:DropDownList ID="ddlTime" runat="server" ClientIDMode="Static"  Width="160px" onchange="ResetTextBoxTime();" ></asp:DropDownList>
					</td>
					<td class="GridViewLabItemStyle" id="tdDuration" style="text-align:center;width:80px;"><input type="text" id="txtDuration" maxlength="30" style="width:100px;display:none" onkeypress="ResetDropDownDuration();">
						<asp:DropDownList ID="ddlDuration" runat="server" ClientIDMode="Static"  Width="100px" onchange="ResetTextBoxDuration();" ></asp:DropDownList>
					</td>
					<td class="GridViewLabItemStyle" id="tdSideEffect" style="text-align:center;width:100px;"><input type="text" id="txtSideEffect" maxlength="30"  style="width:100px;display:none" onkeypress="ResetDropDownSideEffect();">
						<asp:DropDownList ID="ddlSideEffect" ClientIDMode="Static"  runat="server" Width="160px" onchange="ResetTextBoxSideEffect();" ></asp:DropDownList>
					</td>
					<td class="GridViewLabItemStyle" id="tdMeal" style="text-align:center;width:100px;display:none"><input type="text" id="txtMeal" maxlength="30" value='<#=objLabelRow.Meal#>' style="width:100px" onkeypress="ResetDropDownMeal();">
						<asp:DropDownList ID="ddlMeal" ClientIDMode="Static"  runat="server" Width="100px" onchange="ResetTextBoxMeal();" ></asp:DropDownList>
					</td>
                    <td class="GridViewLabItemStyle" id="tdRemarks" style="text-align:center;display:none;width: 80px;"><#=objLabelRow.Remarks#></td>
					<td class="GridViewLabItemStyle" id="tdPname_label" style="text-align:center;display:none;width: 80px;"><#=objLabelRow.PName#></td>
				    <td class="GridViewLabItemStyle" id="tdMRNo" style="text-align:center;display:none;width: 80px;"><#=objLabelRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdMediExpiryDate" style="text-align:center;display:none;width: 80px;"><#=objLabelRow.MedExpiryDate#></td>
					<td class="GridViewLabItemStyle" id="tdItemID" style="text-align:center;display:none;"><#=objLabelRow.ItemID#></td>
					<td class="GridViewLabItemStyle" id="tdQuantity" style="text-align:center;display:none;"><#=objLabelRow.Quantity#></td>
					<td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="text-align:center;display:none;"><#=objLabelRow.LedgerTransactionNo#></td>
					
                    </tr>            
		<#}        
		#>   
			</table>
		</script>
