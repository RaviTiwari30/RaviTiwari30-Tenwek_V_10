<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Miscellaneous.aspx.cs" Inherits="Design_Payroll_Miscellaneous" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
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
    <script type="text/javascript">
        function displayValidationResult() {
            var GridView = document.getElementById('<%=MiscellanousGrid.ClientID %>');
            var DeptId;
            if (GridView.rows.length > 0) {
                for (Row = 1; Row < GridView.rows.length; Row++) {

                    //if (GridView.rows[Row].cell[3].type == "text")
                    //  alert('hi');
                }
            }
        }

        function displayValidationResult() {
            var GridView = document.getElementById('<%=MiscellanousGrid.ClientID %>');
            for (var i = 0; i < GridView.getElementsByTagName("input").length; i++) {
                if (GridView.getElementsByTagName("input").item(i).type == "text") {

                    if (GridView.getElementsByTagName("input").item(i).value == "" || (GridView.getElementsByTagName("input").item(i).value.charAt(0) == "." && GridView.getElementsByTagName("input").item(i).value.length <= 1)) {
                        $("#<%=lblmsgpopup.ClientID %>").text('Please Enter Miscellaneous Amount');
                        GridView.getElementsByTagName("input").item(i).focus();
                        return false;
                    }
                    else {
                        $("#<%=lblmsgpopup.ClientID %>").text('');
                    }

                }

            }
        }
        function ClearAll() {
            $("#<%=lblmsgpopup.ClientID %>").text('');
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {

            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpeCreateGroup")) {
                    $find("mpeCreateGroup").hide();
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Add Miscellaneous Amount </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; height: 11px;" align="right">Employee ID :&nbsp;
                    </td>
                    <td style="width: 18%; height: 11px;">
                        <asp:TextBox ID="txtEmpID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 11px;">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name"></asp:TextBox>
                    </td>
                    <td style="width: 25%; height: 11px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;" align="right"></td>
                    <td style="width: 18%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" TabIndex="3"
                            ToolTip="Click to Search" Text="Search" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Panel ID="pnl" runat="server" ScrollBars="Vertical" Height="380">
                <table border="0" style="width: 500">
                    <tr>
                        <td align="center" colspan="5">
                            <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowCommand="EmpGrid_RowCommand">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Employee_ID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FatherName" HeaderText="FatherName" Visible="false" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DOJ" HeaderText="D.O.J." ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                                CausesValidation="false" CommandArgument='<%# Eval("Employee_ID")%>' CommandName="Select" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
    </div>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnHidden" OnCancelScript="ClearAll()" BehaviorID="mpeCreateGroup">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
        <div runat="server" class="Purchaseheader">
            <b>Employee Detail </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp;Press esc to close
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 788px">
            <tr>
                <td style="height: 16px;" align="center" colspan="4">
                    <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 20%; height: 16px;" align="right">Employee ID :&nbsp;
                </td>
                <td style="width: 20%; height: 16px;" align="left">
                    <asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td style="width: 20%; height: 16px;" align="right">Employee Name :&nbsp;
                </td>
                <td style="width: 20%; height: 16px;" align="left">
                    <asp:Label ID="lblEmpName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%; height: 16px">Department :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblDept" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="right" style="width: 20%; height: 16px">Designation :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblDesi" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%; height: 16px">Date Of Joining :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblDOJ" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="right" style="width: 20%; height: 16px">Father Name :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblFatherName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%; height: 16px">Basic :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblBasic" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
        </table>
        <div id="Div1" runat="server" class="Purchaseheader">
            <b>Miscellaneous</b>&nbsp; &nbsp; &nbsp; &nbsp;
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 788px">
            <tr>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="right" style="width: 20%; height: 16px">Salary Month :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <%--<uc1:EntryDate ID="txtDate" runat="server" />--%>
                    <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                    <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td colspan="4">
                    <br />
                </td>
            </tr>
            <tr>
                <td align="center" colspan="4" style="height: 16px">
                    <asp:GridView ID="MiscellanousGrid" runat="server" OnRowDataBound="AddAmount" CssClass="GridViewStyle"
                        AutoGenerateColumns="False">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                    <asp:Label ID="lblCalType" Visible="false" runat="server" Text='<%# Eval("CalType") %>'></asp:Label>
                                    <asp:Label ID="lblTypeID" Visible="false" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="200px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remuneration" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblInstallmentAmt" runat="server" Text='<%# Eval("RemunerationType") %>'></asp:Label>
                                    <asp:Label ID="lblRemunerationTypeID" runat="server" Visible="false" Text='<%# Eval("RemunerationTypeID") %>'></asp:Label>
                                    <asp:Label ID="lblTrantypeID" runat="server" Visible="false" Text='<%# Eval("TransactionTypeID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="160px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amount" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtAmount" AutoCompleteType="disabled" Width="100" runat="server"
                                        ToolTip="Enter Miscellanous Amount" TabIndex="1" onkeypress="return checkForSecondDecimal(this,event)"
                                        MaxLength="8"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ft1" runat="server" FilterMode="ValidChars" TargetControlID="txtAmount"
                                        ValidChars="." FilterType="Numbers, Custom">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:RequiredFieldValidator ID="reqAmt" runat="server" SetFocusOnError="true" ErrorMessage="Enter Miscellanous Amount"
                                        ValidationGroup="Save" Display="None" ControlToValidate="txtAmount"></asp:RequiredFieldValidator>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td align="left" style="width: 20%; height: 16px">&nbsp;
                </td>
                <td align="center" colspan="2" style="height: 16px">
                    <asp:Button ValidationGroup="Save" ID="btnSave" runat="server" OnClick="btnSave_Click"
                        Text="Save" OnClientClick="return displayValidationResult();" ToolTip="Click to Save"
                        CssClass="ItDoseButton" />
                    &nbsp;
                    <asp:Button ID="btnClose" runat="server" Text="Close" ToolTip="Click to Close" CssClass="ItDoseButton" />
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
        </table>
        <br />
    </asp:Panel>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
</asp:Content>