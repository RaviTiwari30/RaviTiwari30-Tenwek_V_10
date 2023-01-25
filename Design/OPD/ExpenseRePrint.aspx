<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ExpenseRePrint.aspx.cs" Inherits="Design_OPD_ExpenseRePrint" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Expense Re-Print</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="text-align: center; border-collapse: collapse">
                 <tr>
                    <td style="width: 120px; text-align: right;">From Date :&nbsp;</td>
                    <td style="width: 300px; text-align: left;">
                         <asp:TextBox ID="txtfromDate" runat="server" ToolTip="Select From Date" Width="100px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 120px; text-align: right;">To Date :&nbsp;</td>
                    <td style="width: 300px; text-align: left;">
                      <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="100px"
                            TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>

                </tr>


                <tr>
                    <td style="width: 120px; text-align: right;">Expence Type :&nbsp;</td>
                    <td style="width: 300px; text-align: left;">
                        <asp:DropDownList ID="ddlExpenceType" runat="server" Width="146px"
                            AutoPostBack="True" TabIndex="1" ClientIDMode="Static"
                            OnSelectedIndexChanged="ddlExpenceType_SelectedIndexChanged">
                        </asp:DropDownList>
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                    <td style="width: 120px; text-align: right;">Expence To :&nbsp;</td>
                    <td style="width: 300px; text-align: left;">
                        <asp:DropDownList ID="ddlExpenceTo" runat="server" Width="150px" TabIndex="2"
                            Visible="False" ClientIDMode="Static">
                        </asp:DropDownList>
                        
                        <asp:TextBox ID="txtExpenceType" runat="server" Visible="False"  ClientIDMode="Static" MaxLength="50" TabIndex="2"></asp:TextBox>
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>

                </tr>

                <tr>
                    <td style="text-align: left;" colspan="4"> 

  <asp:RadioButtonList ID="rdotype" runat="server" RepeatDirection="Horizontal" RepeatColumns="3">
    <asp:ListItem Text="Payment" Value="0" ></asp:ListItem>
    <asp:ListItem Text="Refund" Value="1"></asp:ListItem>
    <asp:ListItem Text="All" Value="2" Selected="True"></asp:ListItem>

  </asp:RadioButtonList>

                    </td>
                   
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="return validate(this)"
                TabIndex="6" Text="Search" OnClick="btnSearch_Click" />
        </div>

             <asp:Panel ID="pnlHide" runat="server" Visible="false">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expense Details</div>
            <div style="overflow: auto; padding: 3px; width: 950px; height: 340px;">
                <asp:GridView ID="grdExpense" runat="server" AutoGenerateColumns="False" 
                    AllowPaging="False"  CssClass="GridViewStyle" OnRowCommand="grdExpense_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>                        
                         <asp:TemplateField HeaderText="Receipt No.">
                            <ItemTemplate>
                            <asp:Label ID="lblReceiptNo" runat="server" Text='<%# Eval("ReceiptNo") %>'></asp:Label>
                             </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                            <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>'></asp:Label>
                             </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="ExpenceType">
                            <ItemTemplate>
                            <asp:Label ID="lblExpenceType" runat="server" Text='<%# Eval("ExpenceType") %>'></asp:Label>
                             </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="ExpenceTo">
                            <ItemTemplate>
                            <asp:Label ID="lblExpenceTo" runat="server" Text='<%# Eval("ExpenceTo") %>'></asp:Label>
                             </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>

                        <asp:BoundField DataField="Amount" HeaderText="Amount">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px"  />
                        </asp:BoundField>

                         <asp:BoundField DataField="Type" HeaderText="Type">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"  />
                        </asp:BoundField>
                        
                          <asp:BoundField DataField="Depositor" HeaderText="Entry By">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px"  />
                        </asp:BoundField>                        
                       
                        <asp:TemplateField HeaderText="Print"  HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-CssClass="GridViewLabItemStyle">
                                    <ItemTemplate>                                        
                                        <asp:ImageButton ID="imbPrint" runat="server"  CausesValidation="false"
                                            CommandName="Print" ImageUrl="~/Images/print.gif" CommandArgument='<%#Eval("ReceiptNo") +"#"+Eval("Type")%> ' />
                                    </ItemTemplate>
                                </asp:TemplateField> 
                    </Columns>
                </asp:GridView>
            </div>
        </div>
            </asp:Panel>





    </div>
    <script type="text/javascript">
        $(function () {
            $('#txtfromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();

            });

        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });

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
        function validate(btn) {
            if ($("#ddlExpenceType").val() != "0") {
                    if ($("#ddlExpenceTo").val() == "0" && $("#ddlExpenceType option:selected").text() != "Others") {
                        $("#lblMsg").text('Please Select Expence To');
                        $("#ddlExpenceTo").focus();
                        return false;

                    }
            }
          
            if ($("#ddlExpenceType option:selected").text() == "Others" && $.trim($("#txtExpenceType").val())=="") {                
                $("#lblMsg").text('Please Enter Expence To');
                $("#txtExpenceType").focus();
                return false;
            }
           
            btn.disabled = true;
            btn.value = 'Searching...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSearch', '');
        }
    </script>
</asp:Content>

