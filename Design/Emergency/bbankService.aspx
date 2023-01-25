<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" AutoEventWireup="true"
    CodeFile="bbankService.aspx.cs" Inherits="Design_IPD_bbankService" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
<%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" >

        function RestrictDoubleEntry(btn) {
            if (Page_IsValid) {
                btn.disabled = true;
                btn.value = 'Submitting...';
                __doPostBack('btnReceipt', '');
            }
        }
        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                ///__doPostBack('ListBox1','')
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }

                    //listbox.options[0].selected=true;
                }

            }
        }

        function MoveUpAndDownValue(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }

                    //listbox.options[0].selected=true;
                }

            }
        }

        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                //alert(textbox2.value);
                //var f = document.theSource;
                //var listbox = f.measureIndx;
                //var textbox = f.measure_name;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }

                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }

        }
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;

                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
            }
        }

    </script>
    </head>
<body>
    <script type="text/javascript" >

        $(document).ready(function () {
            $('#<%=cmbRefferedBy.ClientID%>').chosen();
        });
    </script>
    <script type="text/javascript" >
        var Ok;
        function ConfirmSave(EntryDt, Name) {
            Ok = confirm('This Service is Already Prescribed By ' + Name + ' Date On ' + EntryDt + '. Do You Want To Prescribe Again ???');
            if (Ok) {
                var btn = document.getElementById("<%=btnAddDirect.ClientID %>");
                btn.click();
            }
            else {
                var btnCancel = document.getElementById("<%=Button2.ClientID %>");
                btnCancel.click();
            }


        }
        function SelectDr(ddl) {
            if ($('#cmbRefferedBy option:selected').val() == "0")
            {
                $('#lblMsg').text('Please Select Doctor');
                return false;
            }
        }
    </script>
    <form id="form1" runat="server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Blood Bank Services</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="right" style="font-size: 10pt;">
                            Category :&nbsp;
                        </td>
                        <td align="left" style="font-size: 10pt">
                            <asp:DropDownList ID="ddlCategory" runat="server" Width="268px" 
                                AutoPostBack="True" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" TabIndex="1" ToolTip="Select Category"/>
                        </td>
                        <td align="left" style="width: 20%; font-size: 10pt;">
                        </td>
                        <td align="left" style="width: 40%; font-size: 10pt; ">
                            Blood Group :&nbsp;
                        <%--<asp:Label ID="lblbloodgroup" runat="server" CssClass="ItDoseLblError"></asp:Label>--%>
                            <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="ItDoseDropdownbox" Width="65px"></asp:DropDownList>
                            <asp:Button ID="btnUpdateBloodgroup" runat="server" CssClass="ItDoseButton" Width="50" Text="Update" OnClick="btnUpdateBloodgroup_Click"/>
                        </td>
                    </tr>
                    <tr >
                        <td align="right" style="font-size: 10pt">
                            Search&nbsp;Blood&nbsp;Bank&nbsp;By&nbsp;Word :&nbsp;
                        </td>
                        <td align="left" colspan="1" rowspan="1" style="width: 30%;">
                            <asp:TextBox ID="txtWord" runat="server" AutoCompleteType="Disabled" 
                                onkeydown="MoveUpAndDownText(txtWord,ListBox1);" onKeyUp="suggestName(txtWord,ListBox1);"
                                Width="268px"  TabIndex="2" ToolTip="Enter To Select Item"></asp:TextBox>
                        </td>
                        <td align="left" style="width: 20%; height: 22px;">
                            <asp:Button ID="btnWord" runat="server" CssClass="ItDoseButton" OnClick="btnWord_Click"
                                Visible="false" Text="Search" Width="75px" />
                        </td>
                        <td align="left" style="width: 40%; height: 22px;">
                            <asp:TextBox onkeydown="MoveUpAndDownText(txtSearch,ListBox1);" ID="txtSearch" onkeyup="suggestName(txtSearch,ListBox1);"
                                runat="server" CssClass="ItDoseTextinputText" Width="168px" Visible="false" />
                    </tr>
                    <tr style="font-size: 10pt">
                        <td align="left" >
                        </td>
                        <td align="left" colspan="3" style="width: 30%;font-size: 12px;">
                            <asp:ListBox ID="ListBox1" runat="server"  Height="144px"
                                Width="510px" ToolTip="Select Item" TabIndex="3"></asp:ListBox>
                            <asp:Button ID="Button1" CausesValidation="false" runat="server" CssClass="ItDoseButton"
                                Width="60px" OnClick="btnSelect_Click" Text="Select"  style="display: none;" />
                            <asp:DropDownList ID="ddlIN" runat="server" Width="86px" CssClass="ItDoseDropdownbox"
                                Visible="False" />
                            <asp:TextBox ID="txtDocCharges" runat="server" Text="0" CssClass="ItDoseTextinputNum"
                                Width="75px" Visible="false" />
                            <cc1:FilteredTextBoxExtender ID="fl1" runat="server" FilterType="Custom,Numbers"
                                ValidChars="." TargetControlID="txtDocCharges" />
                        </td>
                    </tr>
                   <tr style="font-size: 10pt">
                            <td align="right">Doctor :&nbsp;
                            </td>
                            <td align="left" colspan="3">
                                <asp:DropDownList ID="cmbRefferedBy" runat="server" Width="215px" ToolTip="Select Doctor" TabIndex="4"  CssClass="requiredField chosen" ClientIDMode="Static" />
                                Reserve Date :&nbsp;<asp:TextBox ID="ucDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                    Width="100px"></asp:TextBox>&nbsp;Time :&nbsp;
                                <asp:TextBox ID="txtReserveTime" runat="server" ToolTip="Click to Select Time" TabIndex="6"
                                    Width="100px"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtReserveTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtReserveTime"
                                    ControlExtender="MaskedEditExtender2" ForeColor="Red" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save"></cc1:MaskedEditValidator>
                                <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>


                            </td>
                        </tr>
                        <tr style="font-size: 10pt">
                            <td align="right">Quantity :&nbsp;
                            </td>
                            <td align="left" colspan="3">
                                <asp:TextBox ID="txtQty" runat="server" Width="60px" CssClass="ItDoseTextinputNum" TabIndex="7" ToolTip="Enter Quantity" Text="1" MaxLength="3" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers"
                                     TargetControlID="txtQty" />
                                   
                            
                        </td>
                    </tr>
                    
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnSelect" runat="server" CssClass="ItDoseButton" Text="Select" OnClick="btnSelect_Click" OnClientClick="return SelectDr(this);" TabIndex="8" ToolTip="Click To Add Item"/>
            </div>
        </div>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Service Items
                </div>
                <div class="content" style="text-align: center;">
                    <asp:GridView ID="grdItemRate" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                        OnRowDeleting="grdItemRate_RowDeleting">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Category" HeaderText="Category" HeaderStyle-Width="100px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                            <asp:BoundField DataField="SubCategory" HeaderText="Sub Category" HeaderStyle-Width="125px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Item" HeaderText="Item" HeaderStyle-Width="125px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Quantity" HeaderText="Qty." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Date" HeaderText="Reserve Date" HeaderStyle-Width="125px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ReserveTime" HeaderText="Reserve Time" HeaderStyle-Width="125px" ItemStyle-CssClass="GridViewItemStyle"
                                                                   HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Name" HeaderText="Doctor" HeaderStyle-Width="200px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <%--<asp:BoundField DataField="DocCharges" HeaderText="Doc Charges" HeaderStyle-Width="65px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                            <%--<asp:CommandField ShowDeleteButton="True" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                            <asp:CommandField ShowDeleteButton="True" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center"
                            HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image" DeleteText="Remove Service"    DeleteImageUrl="~/Images/Delete.gif"/>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblDoctorID" runat="server" Text='<%# Eval("DoctorID") %>'></asp:Label>
                                    <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                    <div>
                        <asp:Button AccessKey="r" ID="btnReceipt" OnClick="btnReceipt_Click" runat="server"
                            CssClass="ItDoseButton" Text="Save" CausesValidation="False" TabIndex="9" ToolTip="Click To Save Item" OnClientClick="return RestrictDoubleEntry(this);"/>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Label ID="lblPatientID" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblTransactionNo" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblCaseTypeID" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblReferenceCode" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label>
         <asp:Label ID="lblPatientType" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblRoomID" runat="server" Visible="False"></asp:Label>
       <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtQty"
            Display="None" ErrorMessage="Specify Quantity" SetFocusOnError="True">*</asp:RequiredFieldValidator>--%>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDocCharges"
            Display="None" ErrorMessage="Specify Doctor Charges" SetFocusOnError="True">*</asp:RequiredFieldValidator>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
            ShowSummary="False" />
    </div>
        <asp:Button ID="Button2" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton" />
        <asp:Button ID="btnAddDirect" runat="server" Text="Button" OnClick="btnAddDirect_Click" Style="display: none;" CssClass="ItDoseButton" />
          <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-10">
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #f38f78" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Reserved</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #69e6b0" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Issued</b>
                </div>
                 <div class="col-md-14"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <asp:Panel ID="pnlRequest" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto; height: 200px">
                    <asp:GridView ID="grdRequestStatus" TabIndex="22" runat="Server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="100%" 
                        OnRowDataBound="grdRequestStatus_RowDataBound">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Doctor">
                                <ItemTemplate>
                                    <asp:Label ID="lblDName" runat="server" Text='<%# Eval("DName")%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Blood Group">
                                <ItemTemplate>
                                    <asp:Label ID="lblBlood" runat="server" Text='<%# Eval("BloodGroup")%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Component">
                                <ItemTemplate>
                                    <asp:Label ID="lblConponentName" runat="server" Text='<%# Eval("ItemName")%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Req.Qty">
                                <ItemTemplate>
                                    <asp:Label ID="lblQuantity" runat="server" Text='<%# Math.Round(Util.GetDecimal(Eval("Quantity")),2)%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Issue Qty">
                                <ItemTemplate>
                                    <asp:Label ID="lblIssueQuantity" runat="server" Text='<%# Math.Round(Util.GetDecimal(Eval("IssueQty")),2)%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject Qty">
                                <ItemTemplate>
                                    <asp:Label ID="lblRejectQuantity" runat="server" Text='<%# Math.Round(Util.GetDecimal(Eval("RejectQty")),2)%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Pen.Qty">
                                <ItemTemplate>
                                    <asp:Label ID="lblPendQuantity" runat="server" Text='<%# Math.Round(Util.GetDecimal(Eval("PendingQuantity")),2)%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Cross Matched Qty">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsCrossMatch" runat="server" Text='<%# Math.Round(Util.GetDecimal(Eval("CrossMatchQty")),2)%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reserve Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblReserveDate" runat="server" Text='<%# Eval("ReserveDate")%>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="157px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View">
                                <ItemTemplate>
                                    <img id="imgView" class="btn" src="../../Images/view.gif" onclick="ViewItemDetail('<%# Eval("ServiceID")%>');" style="cursor:pointer;" title="Click To View"/>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>

            
            <div id="dvItemdetailModel" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 60%;">
                        <div class="modal-header">
                            <button type="button" class="close" onclick="closeItemdetailModel()" aria-hidden="true">×</button>
                            <h4 class="modal-title"><span id="spnHeaderLabel"> Component Reserved/Issued Details</span> </h4>
                        </div>
                        <div style="max-height: 200px; overflow: auto;" class="modal-body">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-22">
                                    <div id="dvItemdetail"></div> 
                                </div>
                                <div class="col-md-1"></div>
                           </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="closeItemdetailModel()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        var ViewItemDetail = function (serviceRequestID) {
            serverCall('bbankService.aspx/bindItemStockDetail', { ServiceRequestID: serviceRequestID }, function (response) {
                StockData = JSON.parse(response);
                if (StockData.length > 0) {
                    var message = $('#tb_itemStock').parseTemplate(StockData);
                    $('#dvItemdetail').html(message);
                    $('#dvItemdetailModel').showModel();
                }
                else {
                    modelAlert("Stock not Issued");
                }
            });
        }

        var closeItemdetailModel = function () {
            $('#dvItemdetailModel').closeModel();
        }
    </script>
    <script id="tb_itemStock" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grditemStock" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Component Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Stock ID</th>
                <th class="GridViewHeaderStyle" scope="col" >Bag No</th>
                
            </tr>
                </thead><tbody>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center; width:50px;"><#=j+1#></td>
                   <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.ComponentName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:100px;"><#=objRow.BloodStockID #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:115px;"><#=objRow.BBTubeNo #></td>
               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>
         
</body>
</html>
