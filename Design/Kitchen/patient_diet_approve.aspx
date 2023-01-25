<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="patient_diet_approve.aspx.cs" Inherits="Design_Kitchen_patient_diet_approve" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function CheckDate() {
            var d = new Date();
            var month = d.getMonth() + 1;
            var day = d.getDate();
            var output = (day < 10 ? '0' : '') + day + '-' + GetMonth(month) + '-' + d.getFullYear();
            var textboxDate = $('#<%=ucDate.ClientID%>').val();
            if (output > textboxDate) {
                $('#btnSave').attr("disabled", true);
            }
            $('#<%=grdPatientDiet.ClientID%>').html('');
        }
        function GetMonth(month) {
            switch (month) {
                case 1:
                    return "Jan";
                    break;
                case 2:
                    return "Feb";
                    break;
                case 3:
                    return "Mar";
                    break;
                case 4:
                    return "Apr";
                    break;
                case 5:
                    return "May";
                    break;
                case 6:
                    return "Jun";
                    break;
                case 7:
                    return "Jul";
                    break;
                case 8:
                    return "Aug";
                    break;
                case 9:
                    return "Sep";
                    break;
                case 10:
                    return "Oct";
                    break;
                case 11:
                    return "Nov";
                    break;
                case 12:
                    return "Dec";
                    break;
            }
        }

        //function checkLabelAll(objRef) {
        //    var GridView = objRef.parentNode.parentNode.parentNode;
        //    var inputList = GridView.getElementsByTagName("input");
        //    for (var i = 0; i < inputList.length; i++) {
        //        var row = inputList[i].parentNode.parentNode;
        //        if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
        //            if (objRef.checked) {
        //                inputList[i].checked = true;
        //            }
        //            else {
        //                inputList[i].checked = false;
        //            }
        //        }
        //    }
        //}

        function checkLabelAll(Checkbox) {
            var GridView1 = document.getElementById("<%=grdPatientDiet.ClientID %>");
            for (i = 1; i < GridView1.rows.length; i++) {
                GridView1.rows[i].cells[0].getElementsByTagName("INPUT")[0].checked = Checkbox.checked;
            }
        }

        function checkAll(Checkbox) {
            var GridView1 = document.getElementById("<%=grdPatientDiet.ClientID %>");
            for (i = 1; i < GridView1.rows.length; i++) {
                GridView1.rows[i].cells[11].getElementsByTagName("INPUT")[0].checked = Checkbox.checked;
            }
        }

        //function checkAll(objRef) {
        //    var GridView = objRef.parentNode.parentNode.parentNode;
        //    //var inputList = GridView.getElementsByTagName("input");
        //    var inputList = GridView.getElementsByClassName("chkk");
        //    for (var i = 1; i < inputList.length; i++) {
        //        var row = inputList[i].parentNode.parentNode;
        //        if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
        //            if (objRef.checked) {
        //                inputList[i].checked = true;
        //            }
        //            else {
        //                inputList[i].checked = false;
        //            }
        //        }
        //    }
        //}
        function Check_Click(objRef) {
            var row = objRef.parentNode.parentNode;
            var GridView = row.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var headerCheckBox = inputList[0];
                var checked = true;
                if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {
                    if (!inputList[i].checked) {
                        checked = false;
                        break;
                    }
                }
            }
            headerCheckBox.checked = checked;
        }
        function ViewComponent(objRef) {
            var row = objRef.parentNode.parentNode;
            var DietTimeID = $('#<%=ddlDietTiming.ClientID %>').val();
            var subDietID = $(row).find('#lblSubDietID').text();
            var MenuID = $(row).find('#lblDietMenuID').text();
            var TID = $(row).find('#lblTID').text();
            var Date = $('#ucDate').val()
            $.ajax({
                url: "Services/Diet.asmx/getPatientComDetail",
                data: JSON.stringify({ dietTimeID: DietTimeID, subDietID: subDietID, menuID: MenuID, TID: TID, ToDate: Date }),
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var resultObj = jQuery.parseJSON(mydata.d);
                    var resultDiv = " ";
                    resultDiv += " ";
                    resultDiv += "  <table class='GridViewStyle' style='width: 100%'><tr class='GridViewHeaderStyle'><th style='width: 5%;text-align: center'>SNo.</th><th style='width: 55%;text-align: left'>Component</th><th style='width: 10%'>Qty</th><th style='width: 10%'>Type</th><th style='width: 10%'>Unit</th><th style='width: 10%'>Calories</th><th style='width: 10%'>Protein</th><th style='width: 10%'>Sodium</th><th style='width: 10%'>SaturatedFat</th></tr>";
                    for (var i = 0; i < resultObj.length; i++) {
                        resultDiv += "<tr class='GridViewItemStyle'><td style='width: 5%;text-align: center'>" + (i + 1) + "</td><td style='width: 55%'> " + resultObj[i].ComponentName + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Qty + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Type + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Unit + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Calories + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Protein + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Sodium + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].SaturatedFat + "<br /></td></tr>";
                    }
                    resultDiv += "</table>"
                    $('#divcomponenttbldetail').html(resultDiv);
                    $('#divcomponenttbl').show(); 
                },
                error: function (error) {
                    modelAlert('Error: ', jQuery.parseJSON(error.d));
                }
            });
        }
        function ViewSubDietType() {
            var ddlSubDietType = $("#<%=ddlSubDietType.ClientID %>");
            $("#<%=ddlSubDietType.ClientID %> option").remove();
            $.ajax({
                url: "Services/Diet.asmx/getDietSpecification",
                data: '{ DietTypeID: "' + $("#<%=ddlDietType.ClientID %>").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var resultObj = jQuery.parseJSON(mydata.d);
                    if (resultObj.length == 0) {
                        ddlSubDietType.append($("<option></option>").val("0").html("   "));
                    }
                    else {
                        for (i = 0; i < resultObj.length; i++) {
                            ddlSubDietType.append($("<option></option>").val(resultObj[i].SubDietID).html(resultObj[i].Name));
                            $("#<%=txtSubdiet.ClientID %>").val($('#<%= ddlSubDietType.ClientID %> option:selected').val());
                        }
                    }
                    $('#pnlReport').show();

                },
                error: function (error) {
                    modelAlert("Error ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function HideDiv() {
            $('#divComponent').hide();
        }
        function RefreshGrid() {
            $('#<%=grdPatientDiet.ClientID%>').html('');
        }
        function refreshdit() {
            $('#pnlReport').show();
            $("#<%=ddlDietType.ClientID %> option[value='Select']").attr('selected', 'selected');
            ViewSubDietType();
            $('#pnlReport').show();
        }
        $(document).ready(function () {
            $("#<%=txtSubdiet.ClientID %>").val(' ');
            $('#<%=ddlSubDietType.ClientID %>').change(function () {
                $("#<%=txtSubdiet.ClientID %>").val($(this).val());
            });
        });
        function validate() {
            if ($("#<%=ddlDietTiming.ClientID%>").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Diet Timing');
                modelAlert('Please Select Diet Timing');
                $("#<%=ddlDietTiming.ClientID%>").focus();
                return false;
            }
        }

        function ValidateReport() {
            if ($("#<%=ddlDietTiming.ClientID%>").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Diet Timing');
                modelAlert('Please Select Diet Timing');
                $("#<%=ddlDietTiming.ClientID%>").focus();
                return false;
            }
        }

        function validateIssue(btn) {
            document.getElementById('<%=btnIssueAll.ClientID%>').disabled = true;
            document.getElementById('<%=btnIssueAll.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnIssueAll', '');
        }
        function validateFreeze(btn) {
            document.getElementById('<%=btnFreeze.ClientID%>').disabled = true;
            document.getElementById('<%=btnFreeze.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnFreeze', '');
        }

    </script>
    <script type="text/javascript">

        function WriteToFile(data) {
            try {
                window.location = 'barcode://?cmd=' + data + '&test=1&source=Barcode_Source_Diet';
            }
            catch (e) { modelAlert('Error'); }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <b>Freeze/Issue Patient Diet</b>
            <br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server"  style="display:none;"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucDate" onchange="CheckDate();" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFloor" runat="server" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Ward
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlWard" onchange="RefreshGrid();" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Timing
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDietTiming" onchange="RefreshGrid();" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row">
                <div class="col-md-11">
                </div>
                <div class="col-md-4">
                    <asp:Button ID="btnSearch" OnClientClick="return validate()" runat="server" CssClass="ItDoseButton"
                        Text="Search" OnClick="btnSearch_Click" />
                    &nbsp;

                    <asp:Button ID="btnComponentReport" runat="server" Text="Report" OnClick="btnComponentReport_Click" OnClientClick="return ValidateReport();" />
                </div>
                <div class="col-md-8">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-6"></div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lemonchiffon;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Freezed</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellowgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Issued</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightseagreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Received</b>
                        </div>                        
                    </div>
                </div>
            </div>
            <%-- <table style="margin-left: 250px; width: 50%">
                <tr>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lemonchiffon;">&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td style="text-align: left">
                    </td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellowgreen;">&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td style="text-align: left">
                    </td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightseagreen;">&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td style="text-align: left">
                    </td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>
                    </td>
                </tr>
            </table>--%>
        </div>
        <div class="POuter_Box_Inventory" style="overflow-y: scroll; height: 400px">
            <asp:GridView ID="grdPatientDiet" HeaderStyle-CssClass="GridViewHeaderStyle" AutoGenerateColumns="false"
                RowStyle-CssClass="GridViewItemStyle" Width="100%" runat="server" OnRowDataBound="grdPatientDiet_RowDataBound"
                OnRowCommand="grdPatientDiet_RowCommand">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <asp:CheckBox ID="chkLabelAl" runat="server" onclick="checkLabelAll(this);" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkLabl" runat="server" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="label">
                        <ItemTemplate>
                            <asp:ImageButton ImageUrl="~/Images/print.gif" ToolTip="Click To Print Label" ID="btnimgPrint"
                                runat="server" CommandName="PrintLabel" CommandArgument='<%# Eval("IPDNo")+"#"+Eval("PatientID")+"#"+Eval("PName")+"#"+Eval("DietName")+"#"+Eval("SubDietName")+"#"+Eval("MenuName") +"#"+Eval("Room_NAME")%>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="2%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="2%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Type">
                        <ItemTemplate>
                            <asp:Label ID="lbltype" Width="100%" runat="server" Text='<%#Eval("Type") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UHID">
                        <ItemTemplate>
                            <asp:Label ID="lblMRNo" Width="100%" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IPD No.">
                        <ItemTemplate>
                            <asp:Label ID="lblIPDNo" Width="100%" runat="server" Text='<%#Eval("IPDNo") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Patient Name">
                        <ItemTemplate>
                            <asp:Label ID="lblPName" runat="server" Width="100%" Text='<%#Eval("PName") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Diet Type">
                        <ItemTemplate>
                            <asp:Label ID="lblDiet" Width="100%" Text='<%#Eval("DietName") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Sub Diet">
                        <ItemTemplate>
                            <asp:Label ID="lblSubDiet" Width="100%" Text='<%#Eval("SubDietName") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Menu">
                        <ItemTemplate>
                            <asp:Label ID="lblMenu" Width="85%" Text='<%#Eval("MenuName") %>' runat="server"></asp:Label><img
                                id="imgComponent" src="../../Images/view.GIF" alt="View" style="cursor: pointer"
                                onclick="ViewComponent(this);" />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Remarks">
                        <ItemTemplate>
                            <asp:Label ID="lblRemarks" runat="server" Width="95%" Text='<%#Eval("Remarks") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <asp:CheckBox ID="checkAll" runat="server" onclick="checkAll(this);" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkSelect" onclick="Check_Click(this)" runat="server" />
                            <asp:Label ID="lblTID" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;" Text='<%#Eval("TransactionID") %>'></asp:Label>
                            <asp:Label ID="lblSubDietID" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;"
                                Text='<%#Eval("SubDietID") %>'></asp:Label>
                            <asp:Label ID="lblDietMenuID" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;"
                                Text='<%#Eval("DietMenuID") %>'></asp:Label>
                            <asp:Label ID="lblFreeze" Width="100%" runat="server" Visible="false" Text='<%#Eval("IsFreeze") %>'></asp:Label>
                            <asp:Label ID="lblID" Width="100%" runat="server" Visible="false" Text='<%#Eval("RequestID") %>'></asp:Label>
                            <asp:Label ID="lblReceive" Width="100%" runat="server" Visible="false" Text='<%#Eval("IsReceived") %>'></asp:Label>
                            <asp:Label ID="lblIssue" Width="100%" runat="server" Visible="false" Text='<%#Eval("IsIssued") %>'></asp:Label>
                            <asp:Label ID="lblPanelID" Width="100%" runat="server" Visible="false" Text='<%#Eval("PanelID") %>'></asp:Label>
                            <asp:Label ID="lblPatient_Type" Width="100%" runat="server" Visible="false" Text='<%#Eval("Patient_Type") %>'></asp:Label>
                            <asp:Label ID="lblIPDCaseTypeID" Width="100%" runat="server" Visible="false" Text='<%#Eval("IPDCaseTypeID") %>'></asp:Label>
                            <asp:Label ID="lblRoomName" Width="100%" runat="server" Visible="false" Text='<%#Eval("Room_NAME") %>'></asp:Label>
                            <asp:Label ID="lblRoom_ID" Width="100%" runat="server" Visible="false" Text='<%#Eval("RoomID") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Issue">
                        <ItemTemplate>
                            <asp:Button ID="btnIssue" runat="server" OnClick="btnIssue_Click" Text="Issue" CssClass="ItDoseButton" />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <asp:Button ID="btnFreeze" runat="server" ClientIDMode="Static" CssClass="ItDoseButton"
                Text="Freeze" OnClick="btnFreeze_Click" OnClientClick="return validateFreeze(this)" />
            &nbsp;<asp:Button ID="btnIssueAll" runat="server" Visible="false" CssClass="ItDoseButton"
                Text="IssueAll" OnClick="btnIssueAll_Click" OnClientClick="return validateIssue(this)" />
            &nbsp;<%--<asp:Button ID="btnReport" runat="server" Visible="false" CssClass="ItDoseButton"
                Text="Report" OnClientClick="refreshdit();" />--%>
            <input type="button"  id="btnReport" value="Report" runat="server" onclick="refreshdit();" />
        </div>
         
            <div id="divcomponenttbl"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 900px; height:350px; ">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divcomponenttbl" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Component Detail</h4>
				</div>
				<div class="modal-body"> 
                    <div id="divcomponenttbldetail"></div>
				</div>
<%--				  <div class="modal-footer" style="text-align:center;"> 
				</div>--%>
			</div>
		</div>
	</div>
       
        
     <%--   <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
            DropShadow="true" TargetControlID="btnReport" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlReport" PopupDragHandleControlID="dragHandle">
        </cc1:ModalPopupExtender>--%>


        <div id="pnlReport"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 800px;height: 230px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlReport" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Select Report Type</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                         <div class="col-md-5" >
                                             <b class="pull-left">Diet Timing  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-7"> 
                       <asp:DropDownList ID="ddltiming" runat="server" Width="182px">
                        </asp:DropDownList>
                    </div> 
                                              <div class="col-md-5" >
                                             <b class="pull-left">Menu Name  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-7"> 
                     <asp:DropDownList ID="ddlmenu" runat="server" Width="180px">
                        </asp:DropDownList>
                    </div> 
				</div>
			 	  <div class="row" ">
                                         <div class="col-md-5" >
                                             <b class="pull-left">Diet Type  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-7"> 
                                           <asp:DropDownList ID="ddlDietType" runat="server" Width="180px" onchange="ViewSubDietType()">
                        </asp:DropDownList>
                    </div> 
                                              <div class="col-md-5" >
                                             <b class="pull-left">Diet Specification  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-7"> 
                                            <asp:DropDownList ID="ddlSubDietType" runat="server" Width="182px">
                        </asp:DropDownList>
                        <asp:TextBox ID="txtSubdiet" runat="server" Style="display: none"></asp:TextBox>
                    </div> 
				</div>
                    <div class="row">
                         <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal"
                        CssClass="ItDoseRadiobuttonlist">
                        <asp:ListItem Text="Summary" Value="Summary" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Detail" Value="Detail"></asp:ListItem>
                    </asp:RadioButtonList>
                    </div>
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                                      <asp:Button ID="btnReportDetail" runat="server" CssClass="ItDoseButton" Text="Report"
                    OnClick="btnReportDetail_Click" />
                <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
				</div>
			</div>
		</div>
	</div>
    </div>
</asp:Content>
