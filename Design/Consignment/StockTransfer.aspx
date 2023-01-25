<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="StockTransfer.aspx.cs" Inherits="Design_Consignment_StockTransfer" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">
        var nav = window.Event ? true : false;
        if (nav) {
            window.captureEvents(Event.KEYDOWN);
            window.onkeydown = NetscapeEventHandler_KeyDown;
        } else {
            document.onkeydown = MicrosoftEventHandler_KeyDown;
        }

        function NetscapeEventHandler_KeyDown(e) {
            if (e.which == 13 && e.target.type != 'textarea' && e.target.type != 'submit') {
                return false;
            }
            return true;
        }

        function MicrosoftEventHandler_KeyDown() {
            if (event.keyCode == 13 && event.srcElement.type != 'textarea' &&
            event.srcElement.type != 'submit')
                return false;
            return true;
        }

        function ShowAlertBox(label) {
            ModelAlert(label);
        }
    </script>

    <script type="text/javascript">
        //function clickButton() {
        //    if ($.trim($("#txtTransferQty").val()) != "" && $.trim($("#txtTransferQty").val()) != "0") {
        //        __doPostBack('ctl00$ContentPlaceHolder1$btnAdd', '');
        //    }
        //    else
        //        return false;
        //}
        function clickButton(e) {

            if ($.trim($("#txtTransferQty").val()) != "" && $.trim($("#txtTransferQty").val()) != "0") {
                if (e.which == "13")
                    __doPostBack('ctl00$ContentPlaceHolder1$btnAdd', '');

            }
            else
                return false;
        }
        $(document).ready(function () {
            $('#ucDate').change(function () {
                ChkDate();

            });

            $('#toDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDate').val() + '",DateTo:"' + $('#toDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnAdd').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnAdd').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <script type="text/javascript">

        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = ListBox1.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                searchByCPTCode('', document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtWord.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('<%=btnAdd.ClientID%>'), values, keys, e)
            });

            $('#<%=txtWord.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtSearch.ClientID%>'), '', document.getElementById('<%=txtWord.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('<%=btnAdd.ClientID%>'), values, keys, e)

            });
        });





    </script>
    <script type="text/javascript">
        function chkQty() {
            if ($.trim($("#txtTransferQty").val()) == "") {
                $("#lblMsg").text('Please Enter Qty.');
                $("#txtTransferQty").focus();
                return false;
            }
            if ($.trim($("#txtTransferQty").val()) == "0") {
                $("#lblMsg").text('Please Enter Valid Qty.');
                $("#txtTransferQty").focus();
                return false;
            }
        }
        function RestrictDoubleEntry(btn) {
            if ($("#txtNarration").val() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Narration');
                $("#txtNarration").focus();
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Issue Consignment To Patient</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details
            </div>
            <div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 10%; text-align: right">Patient Name :&nbsp;</td>
                        <td style="width: 23%; text-align: left">
                            <asp:TextBox ID="txtName" runat="server" Width="209px" MaxLength="20" AutoCompleteType="Disabled" TabIndex="1"></asp:TextBox></td>
                        <td style="width: 10%; text-align: right">IPD&nbsp;No.&nbsp;:&nbsp;</td>
                        <td style="width: 23%; text-align: left">
                            <asp:TextBox ID="txtCRNo" runat="server" Width="100px" MaxLength="10" AutoCompleteType="Disabled" TabIndex="2"></asp:TextBox></td>
                        <td style="width: 10%" visible="false">
                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                CssClass="ItDoseButton" /></td>
                        <td style="width: 24%">
                            <%--  <cc1:FilteredTextBoxExtender ID="CrNo" runat="server" FilterMode="ValidChars"
                                FilterType="Numbers" TargetControlID="txtCRNo">
                            </cc1:FilteredTextBoxExtender>--%>
                            <asp:RadioButton ID="rbtStorToDept" Text="To Department" runat="server" CssClass="ItDoseRadiobutton"
                                Width="150px" GroupName="a" Style="display: none;" />&nbsp;
                                    <asp:RadioButton ID="rbtStorToPat" Text="To Patient" runat="server" Checked="true"
                                        CssClass="ItDoseRadiobutton" Width="150px" GroupName="a" Style="display: none;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%"></td>
                        <td colspan="5">
                            <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowCommand="grdPatient_RowCommand">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="IPD No.">
                                        <ItemTemplate>
                                            <%# Util.GetString( Eval("TransactionID")).Replace("ISHHI","") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Patient Name">
                                        <ItemTemplate>
                                            <%#Eval("PName") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Address">
                                        <ItemTemplate>
                                            <%#Eval("Address") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="ASelect"
                                                ImageUrl="~/Images/view.gif" CommandArgument='<%# Eval("TransactionID") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="50px" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <asp:Panel ID="ptnDetail" runat="server" Visible="false">
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>


                            <td style="width: 15%; text-align: right">Patient Name :&nbsp;</td>
                            <td style="width: 23%; text-align: left">
                                <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 10%; text-align: right">IPD No. :&nbsp;</td>
                            <td style="width: 23%; text-align: left">
                                <asp:Label ID="lblTransactionNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 10%; text-align: right">UHID :&nbsp;</td>
                            <td style="width: 24%; text-align: left">
                                <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:Label ID="lblPatientType" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                                <asp:Label ID="lblIPDCaseType_ID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                                <asp:Label ID="lblRoom_ID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Room :&nbsp;</td>
                            <td style="width: 23%; height: 16px; text-align: left">
                                <asp:Label ID="lblRoomNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 10%; height: 16px; text-align: right">Doctor :&nbsp;</td>
                            <td style="width: 23%; height: 16px; text-align: left">
                                <asp:Label ID="lblDoctorName" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 10%; height: 16px; text-align: right">Panel :&nbsp;</td>
                            <td style="width: 24%; height: 16px; text-align: left">
                                <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        </tr>
                        <tr id="trMembership" runat="server">
                            <td style="width: 15%; text-align: right">Card No. :&nbsp;</td>
                            <td style="width: 23%; height: 16px; text-align: left">
                                <asp:Label ID="lblMembershipCardNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 10%; height: 16px; text-align: right">Valid UpTo :&nbsp;</td>
                            <td style="width: 23%; height: 16px; text-align: left">
                                <asp:Label ID="lblMembershipCardDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 10%; height: 16px; text-align: right">&nbsp;</td>
                            <td style="width: 24%; height: 16px; text-align: left"></td>
                        </tr>
                    </table>
                </asp:Panel>

            </div>
        </div>
        <asp:Panel ID="pnldetail" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">


                <table style="width: 99%; border-collapse: collapse">
                    <tr>
                        <td style="width: 15%; text-align: right">
                            <asp:Label ID="lblDept" runat="server" Visible="false" Text="Department"></asp:Label></td>
                        <td style="width: 30%; text-align: left">
                            <asp:DropDownList ID="ddlDepartment" Visible="false" runat="server" CssClass="ItDoseDropdownbox"
                                Width="180px">
                            </asp:DropDownList></td>
                        <td style="width: 10%; text-align: right">
                            <asp:Label ID="lblPanelID" runat="server" Visible="false"></asp:Label></td>
                        <td style="width: 15%">
                            <a href="javascript:void(0);" onclick="window.open('getItemBySalt.aspx?cmd=1','getItemBySalt','width=900,height=500,toolbar=1,resizable=0');"></a>
                        </td>
                        <td style="width: 30%; display: none">
                            <a href="javascript:void(0);" onclick="window.open('getItemBySalt.aspx?cmd=1','getItemBySalt','width=900,height=500,toolbar=1,resizable=0');">Get Item by salt</a></td>
                    </tr>
                    <tr>
                        <td style="width: 15%; text-align: right">By First Name :&nbsp; </td>
                        <td style="width: 30%; text-align: left">
                            <asp:TextBox ID="txtSearch" AutoCompleteType="Disabled" runat="server" Width="200px" MaxLength="50" TabIndex="3" />
                        </td>
                        <td style="width: 10%; text-align: right">
                            <asp:Button ID="btnWord" runat="server" CssClass="ItDoseButton" OnClick="btnWord_Click" Style="display: none"
                                Text="Search" /></td>
                        <td style="width: 15%; text-align: left">Search&nbsp;By&nbsp;Any&nbsp;Word&nbsp;:&nbsp;</td>
                        <td style="width: 30%">


                            <asp:TextBox ID="txtWord" runat="server" AutoCompleteType="Disabled" Width="200px" MaxLength="50"></asp:TextBox>




                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%"></td>
                        <td colspan="4">
                            <asp:ListBox ID="ListBox1" runat="server" CssClass="ItDoseDropdownbox"
                                Width="740px" Height="150px"></asp:ListBox></td>
                    </tr>
                    <tr>
                        <td style="width: 15%; text-align: right">Quantity :</td>
                        <td style="width: 30%; text-align: left">

                            <asp:TextBox ID="txtTransferQty" runat="server" CssClass="ItDoseTextinputNum"
                                Width="60px" ClientIDMode="Static" onkeyup="return clickButton(event)" TabIndex="4"></asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                            <cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" TargetControlID="txtTransferQty" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </td>

                    </tr>
                    <tr style="display: none;">
                        <td style="text-align: right">&nbsp;&nbsp;From&nbsp;Date :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="ucDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                Width="100px" onchange="ChkDate();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right">&nbsp;&nbsp;To&nbsp;Date :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="toDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                Width="100px" onchange="ChkDate()" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caltoDate" runat="server" TargetControlID="toDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center" colspan="5">
                            <asp:Button ID="btnAdd" ClientIDMode="Static" runat="server" Text="Add" OnClick="btnAdd_Click" CssClass="ItDoseButton"
                                OnClientClick="return chkQty()" />

                        </td>

                    </tr>
                    <tr>
                        <td colspan="5">
                            <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="Server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblType_ID" runat="server" Text='<%# Eval("Type_ID") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Expiry" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Eval("MedExpiry")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="BuyPrice" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="RoundOff" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRoundOff" runat="server" Text='<%# Eval("RoundOff") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Octroi" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblOctroi" runat="server" Text='<%# Eval("Octroi") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Freight" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblFreight" runat="server" Text='<%# Eval("Freight") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblVendorLedgerNo" runat="server" Text='<%# Eval("VendorLedgerNo") %>'></asp:Label>
                                            <asp:Label ID="lblInvoiceNo" runat="server" Text='<%# Eval("BillNo") %>'></asp:Label>
                                            <asp:Label ID="lblChallanNo" runat="server" Text='<%# Eval("ChallanNo") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="MRP" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Avail Qty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Unit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="IssueQty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtIssueQty" runat="server" CssClass="ItDoseTextinputNum" Width="50px"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers" ValidChars="." TargetControlID="txtIssueQty">
                                            </cc1:FilteredTextBoxExtender>
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("ID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblMedExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblDeptLedgerNo" runat="server" Text='<%# Eval("DeptLedgerNo") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblTaxID" runat="server" Text='<%# Eval("TaxID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblTaxPer" runat="server" Text='<%# Eval("TaxPer") %>' Visible="False"></asp:Label>

                                            <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%# Eval("SaleTaxPer") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblType" runat="server" Text='<%# Eval("TYPE") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval(" DiscountPer") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblIGSTPercent" runat="server" Text='<%# Eval("IGSTPercent") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblCGSTPercent" runat="server" Text='<%# Eval("CGSTPercent") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSGSTPercent" runat="server" Text='<%# Eval("SGSTPercent") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblGSTType" runat="server" Text='<%# Eval("GSTType") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSpecialDiscPer" runat="server" Text='<%# Eval("SpecialDiscPer") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblisDeal" runat="server" Text='<%# Eval("isDeal") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblConversionFactor" runat="server" Text='<%# Eval("ConversionFactor") %>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%"></td>
                        <td colspan="4">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
                        <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton"
                            OnClick="btnAddItem_Click" Visible="false" /></td>
                    </tr>
                </table>

            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Item Details
                </div>
                <div class="content">
                    <div class="row">
                        <div class="col-md-4">
                            <label style="text-align: right">
                                Total Amount :</label>
                        </div>
                        <div class="col-md-20">
                            <asp:Label ID="lblTotalAmount" runat="server" CssClass="ItDoseLblError" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:GridView ID="grdItemDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdItemDetails_RowCommand" Width="140%">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Eval("ItemName") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="BatchNo" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Eval("BatchNumber")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblIssueQty" runat="server" Text='<%#Eval("IssueQty") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Unit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Eval("UnitType") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <%#Eval("Type_ID") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="UnitPrice" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Math.Round(Util.GetDouble(Eval("UnitPrice")),2) %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="MRP" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMRP" runat="server" Text='<%# Math.Round(Util.GetDouble(Eval("MRP")),2) %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Amt" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Math.Round(Util.GetDouble(Eval("Amount")),2) %>
                                            <asp:Label Visible="False" ID="lblOctroi" runat="server" Text='<%#Eval("Octroi") %>'></asp:Label>
                                            <asp:Label Visible="False" ID="lblRoundOff" runat="server" Text='<%#Eval("RoundOff") %>'></asp:Label>
                                            <asp:Label Visible="False" ID="lblFreight" runat="server" Text='<%#Eval("Freight") %>'></asp:Label>
                                            <asp:Label Visible="False" ID="lblVendorLedgerNo" runat="server" Text='<%#Eval("VendorLedgerNo") %>'></asp:Label>
                                            <asp:Label Visible="False" ID="lblBillNo" runat="server" Text='<%#Eval("BillNo") %>'></asp:Label>
                                            <asp:Label Visible="False" ID="lblChallanNo" runat="server" Text='<%#Eval("ChallanNo") %>'></asp:Label>
                                            <asp:Label Visible="False" ID="lblMedExpDate" runat="server" Text='<%#Eval("MedExpiryDate") %>'></asp:Label>
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategory") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblDeptLegerNo" runat="server" Text='<%# Eval("DeptLedgerNo") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblTaxID" runat="server" Text='<%# Eval("TaxID") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="lblTaxPer" runat="server" Text='<%# Eval("TaxPer") %>' Visible="False"></asp:Label>


                                            <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%# Eval("SaleTaxPer") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblType" runat="server" Text='<%# Eval("TYPE") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval(" Discount") %>' Visible="False"> </asp:Label>
                                            <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblIGSTPercent" runat="server" Text='<%# Eval("IGSTPercent") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblCGSTPercent" runat="server" Text='<%# Eval("CGSTPercent") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSGSTPercent" runat="server" Text='<%# Eval("SGSTPercent") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblGSTType" runat="server" Text='<%# Eval("GSTType") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSpecialDiscPer" runat="server" Text='<%# Eval("SpecialDiscPer") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblisDeal" runat="server" Text='<%# Eval("isDeal") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblConversionFactor" runat="server" Text='<%# Eval("ConversionFactor") %>' Visible="false"></asp:Label>

                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">

                <table style="width: 100%; border-collapse: collapse">

                    <tr>
                        <td style="text-align: right">Narration :</td>
                        <td style="text-align: left">
                            <table style="width: 100%; border-collapse: collapse">
                                <tr>
                                    <td style="width: 60%">
                                        <asp:TextBox ID="txtNarration" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputText" Width="560px" TextMode="MultiLine"></asp:TextBox>

                                    </td>
                                    <td style="text-align: left; width: 40%">
                                        <span style="color: red; font-size: 10px;" class="shat">*</span>

                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                </table>

            </div>
            <asp:Panel ID="pnlSave" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center;">

                    <asp:CheckBox ID="chkPrint" runat="server" Text="Print" Checked="true" />
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                        OnClick="btnSave_Click" ValidationGroup="Save" OnClientClick="return RestrictDoubleEntry(this);" />
                    <asp:Button ID="btnAddPopUpItem" runat="server" CausesValidation="false" OnClick="btnAddFromPopUp_Click"
                        Style="display: none;" Text="Button" />

                </div>
            </asp:Panel>
        </asp:Panel>
    </div>





</asp:Content>
