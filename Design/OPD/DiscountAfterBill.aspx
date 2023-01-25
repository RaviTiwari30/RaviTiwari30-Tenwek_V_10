<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DiscountAfterBill.aspx.cs" Inherits="Design_OPD_DiscountAfterBill" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="Content1">
    <script type="text/javascript" src="../Common/Search.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#txtBillNo').focus();
        });
        function RestrictDoubleEntry(btn) {
            var con = 0;
            if ($("#ddlApproveBy").val() == "0") {
                $("#ddlApproveBy").focus();
                $("#lblMsg").text('Please Select Approved By');
                con = 1;
                return false;
            }
            if (($("#txtDiscount").val() == "") || ($("#txtDiscount").val() < "0")) {
                $("#txtDiscount").focus();
                $("#lblMsg").text('Please Enter Discount');
                con = 1;
                return false;
            }
            if (con == "0") {
                btn.disabled = true;
                btn.value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

            }

        }



        function sum() {
            var ValidChars = "0123456789.";

            var AllID = (document.getElementById("ctl00_ContentPlaceHolder1_lbl").value).split('*');
            var i, j;
            var total;
            total = 0;


            for (i = 1 ; i < AllID.length ; i++) {
                var Ctrs = AllID[i].split('#');
                var temp, Qty;

                temp = trim(document.getElementById(Ctrs[0]).value);
                Qty = trim(document.getElementById(Ctrs[1]).value);

                for (j = 0 ; j < temp.length  ; j++) {
                    Char = temp.charAt(j);
                    if (ValidChars.indexOf(Char) == -1) {
                        alert(" Invalid Character ");
                        return;
                    }
                }

                for (j = 0 ; j < Qty.length  ; j++) {
                    Char = Qty.charAt(j);
                    if (ValidChars.indexOf(Char) == -1) {
                        alert(" Invalid Character ");
                        return;
                    }
                }

                if (temp != "") {
                    total = total + eval(eval(temp) * eval(Qty));
                }
            }

            document.getElementById("ctl00_ContentPlaceHolder1_txtTotal").value = total;

        }

        function LTrim(value) {

            var re = /\s*((\S+\s*)*)/;
            return value.replace(re, "$1");

        }
        function RTrim(value) {

            var re = /((\s*\S+)*)\s*/;
            return value.replace(re, "$1");

        }

        // Removes leading and ending whitespaces
        function trim(value) {

            return LTrim(RTrim(value));

        }
        function NetPercAmount(ctrl) {
            sum();
            var discount = ctrl.value;

            if (discount != '') {
                var total = document.getElementById('ctl00_ContentPlaceHolder1_txtTotal').value;
                document.getElementById('ctl00_ContentPlaceHolder1_txtTotal').value = parseFloat(total) - ((parseFloat(total) * parseFloat(discount)) / 100);
            }
        }



        function ClickSelectbtn(e, btnName) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            if (window.event.keyCode == 13) {
                var btn = document.getElementById(btnName);
                alert(btn);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                    return false;
                }
            }
        }
        function NetAmount(ctrl) {
            sum();
            var discount = ctrl.value;
            if (discount != '') {
                var total = document.getElementById('ctl00_ContentPlaceHolder1_txtTotal').value;
                document.getElementById('ctl00_ContentPlaceHolder1_txtTotal').value = parseFloat(total) - parseFloat(discount);
            }
        }

        function chkReceipt() {
            if (($("#txtBillNo").val() == "") && $("#txtReceiptNo").val() == "") {
                $("#lblMsg").text('Please Enter Bill No. OR Receipt No.');
                $("#txtBillNo").focus();
                return false;
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
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
                            return false;
                    }
                }
            }
            return true;
        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Discount After Bill </b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
            </cc1:ToolkitScriptManager>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Patient Details&nbsp;</div>
            <table style="width: 100%">


                <tr style="display:none">
                    <td style="width: 15%; text-align: right;" colspan="2">
                    </td>
                    <td style="width: 35%" colspan="2">
                       
                    </td>
                    <td style="width: 15%; text-align: right;display:none">Receipt No. :&nbsp;
                    </td>
                    <td style="width: 35%;display:none">
                        <asp:TextBox ID="txtReceiptNo" runat="server" AutoCompleteType="Disabled" TabIndex="2"
                            ToolTip="Enter Receipt No." MaxLength="30" ClientIDMode="Static"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 359px; text-align:right" >Bill No. :&nbsp;</td>
                    <td style="text-align:left">
                       <asp:TextBox ID="txtBillNo" runat="server" AutoCompleteType="Disabled" ToolTip="Enter Bill No."
                            TabIndex="1" MaxLength="30" ClientIDMode="Static"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                         <asp:Button ID="btnSearch" TabIndex="2" CssClass="ItDoseButton" OnClientClick="return chkReceipt()" runat="server" Text="Search" OnClick="btnSearch_Click" />
                    </td>
                    <td  style="text-align:left">
                       

                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Details&nbsp;
                </div>
                <table style="width: 100%">
                    <tr>

                        <td style="width: 20%; text-align: right">UHID :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 20%; text-align: right">Patient Name :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>

                        <td style="width: 20%; text-align: right">Sex :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblGender" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblLedgerTransactionNo" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblTypeofTranx" runat="server" Visible="false"></asp:Label>
                        </td>
                        <td style="width: 20%; text-align: right">DOB/Age :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:Label ID="lblDOB" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>

                        <td style="width: 20%; text-align: right">Receipt
                    Amount :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:Label ID="lblAmount" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 20%; text-align: right">Doctor :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblDoctor" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblFileType" runat="server" Visible="false"></asp:Label>
                           <asp:Label ID="lblGovTaxPer" runat="server" Visible="false"></asp:Label> 
                        </td>
                    </tr>
                    <tr>

                        <td style="width: 20%; text-align: right"></td>
                        <td style="width: 30%;"></td>
                        <td style="width: 20%; text-align: left"></td>
                        <td style="width: 30%;"></td>
                    </tr>
                </table>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Prescribed Investigation
                </div>
               

                    <asp:GridView ID="grdItemRate" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" TabIndex="7">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>



                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="ItemName" HeaderText="Investigation">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                            </asp:BoundField>

                            <asp:BoundField DataField="Date" HeaderText="Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:BoundField>

                            <asp:TemplateField HeaderText="Quantity">
                                <ItemTemplate>
                                    <asp:Label AccessKey="q" ID="txtQuantity" runat="server" Width="65px" Text='<%# Eval("Quantity") %>' CssClass="ItDoseTextinputNum" TabIndex="7" />

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>

                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Rate">
                                <ItemTemplate>
                                    <asp:Label ID="txtRate" runat="server" Text='<%# Eval("Rate") %>' Width="65px" CssClass="ItDoseTextinputNum" AccessKey="r" TabIndex="8" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkItem" runat="server" Enabled='<%# Util.GetBoolean(Eval("IsRefund")) %>' Visible="false" />
                                    <asp:Label runat="server" ID="lblLedgerTnxID" Text='<%# Eval("LedgerTnxID") %>' Visible="false" />
                                    <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("Quantity") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblTypeOfTnx" runat="server" Text='<%# Eval("TypeOfTnx") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblTransactionTypeID" runat="server" Text='<%# Eval("TransactionTypeID") %>' Visible="false"></asp:Label>



                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                    

            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Prescribed Investigation
                </div>
                <table style="width: 100%">
                    <tr>
                        <td style="width: 20%; text-align: right">Gross Amount :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblGrossAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 20%; text-align: right">Previous
              Discount :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblDiscount" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>

                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right">RoundOff :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 20%; text-align: right">Gov. Tax Amount
               :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblGovTaxAmount" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>

                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right">Net Amount :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:Label ID="lblNetAmount" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 20%; text-align: right">Paid Amount :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:Label ID="lblPaidAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                    </tr>
                    <tr>

                        <td style="width: 20%; text-align: right">Additional Disc. :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:TextBox ID="txtDiscount" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                                TabIndex="1" onkeypress="return checkForSecondDecimal(this,event)" Width="73px"></asp:TextBox> <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                TargetControlID="txtDiscount" ValidChars=".0123456789">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="rq2" runat="server" ControlToValidate="txtDiscount"
                                Display="None" ErrorMessage="Specify Rate" SetFocusOnError="true" Text="*" ValidationGroup="aa"></asp:RequiredFieldValidator>
                        </td>
                        <td style="width: 20%; text-align: right">Approved By :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:DropDownList ID="ddlApproveBy" runat="server" Width="160px" ClientIDMode="Static">
                            </asp:DropDownList>
                            <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>
                    </tr>
                    <tr>

                        <td style="width: 20%; text-align: right">Reason :&nbsp;</td>
                        <td style="width: 30%;">
                            <asp:TextBox ID="txtReason" runat="server" Width="240px" MaxLength="50"></asp:TextBox></td>
                        <td style="width: 20%; text-align: right"></td>
                        <td style="width: 30%;"></td>
                    </tr>
                </table>

            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Button ID="btnSave" Text="Save" runat="server" CssClass="ItDoseButton" OnClientClick="return RestrictDoubleEntry(this);" UseSubmitBehavior="false" OnClick="btnSave_Click" AccessKey="s" TabIndex="8" ValidationGroup="aa" />&nbsp;
       
            </div>
        </asp:Panel>
    </div>
</asp:Content>

