<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="Appointmentletter.aspx.cs" Inherits="Design_Payroll_Appointmentletter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function CalculateRemuneration() {

        }
    </script>

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtEmployeeName.ClientID %>').val();
            var cards = $('#<%=lblName.ClientID %>').val();
            var cardss = $('#<%=txtAuthorityName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtEmployeeName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            if (cards.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=lblName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            if (cardss.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtAuthorityName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
            }

        }
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
            var card = $('#<%=txtEmployeeName.ClientID %>').val();
            var cards = $('#<%=lblName.ClientID %>').val();
            var cardss = $('#<%=txtAuthorityName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtEmployeeName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (cards.charAt(0) == ' ') {
                $('#<%=lblName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (cardss.charAt(0) == ' ') {
                $('#<%=txtAuthorityName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "." || keychar == "/" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
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
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtExpectations.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtExpectations.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Letter of Appointment </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <asp:Panel ID="tbl1" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Criteria
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee ID
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmployeeID" MaxLength="20" runat="server" TabIndex="1" onkeypress="return check(event)"
                                    ToolTip="Enter Employee ID"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmployeeName" runat="server" onkeypress="return check(event)"
                                    onkeyup="validatespace();" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <asp:Button ID="btnSearch" runat="server" Text="Search" TabIndex="3" ToolTip="Click to Search"
                                    OnClick="btnSearch_Click" CssClass="ItDoseButton" />
                            </div>
                        </div>

                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Results
                </div>
                <div class="row">
                    <div class="col-md-22" align="center">
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
                                <asp:BoundField DataField="EmployeeID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="500px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FatherName" HeaderText="Father Name" Visible="false" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
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
                                            CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>' CommandName="Select" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Employee Detail
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee ID
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblEmployeeID" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblDepartment" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Designation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblDesignation" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Date Of Joining
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="txtDOJ" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Job Timing
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="txtJobTiming" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Appointment Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" Enabled="false" CssClass="pull-left">
                                    <asp:ListItem Selected="True">Staff</asp:ListItem>
                                    <asp:ListItem>Doctor</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Appointment Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAppointmentDate" runat="server"
                                    ToolTip="Select Appointment Date" Style="margin-left: 0px"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                    Format="dd-MMM-yyyy" TargetControlID="txtAppointmentDate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Grade
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblGrade" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-16">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Joining Location
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtAddress" runat="server" Height="130px" ReadOnly="true"
                                            TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Job Expectations
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtExpectations" runat="server" Height="130px"
                                            TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Total Remuneration
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtTotalRemuneration" runat="server" ReadOnly="true"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="fc4" runat="server" FilterMode="ValidChars"
                                            FilterType="Numbers,Custom" TargetControlID="txtTotalRemuneration"
                                            ValidChars=".">
                                        </cc1:FilteredTextBoxExtender>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Instructions From
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtInstruction" runat="server"
                                            onkeypress="return check(event)" onkeyup="validatespace();"
                                            ToolTip="Enter Intruction From"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Work Hours
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtWorkHrs" runat="server" onkeypress="return check(event)"
                                            onkeyup="validatespace();" ToolTip="Enter Work Hrs" Width="85%"></asp:TextBox>Hrs
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterMode="ValidChars"
                                            FilterType="Numbers,Custom" TargetControlID="txtWorkHrs">
                                        </cc1:FilteredTextBoxExtender>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Authority Name
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:TextBox ID="txtAuthorityName" runat="server"
                                            onkeypress="return check(event)" onkeyup="validatespace();"
                                            ToolTip="Enter Authority Name"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <asp:GridView ID="EarningGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Name">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblTypeID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                                <asp:Label ID="lblName0" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Amount">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtAmount" runat="server" AutoCompleteType="disabled" MaxLength="8"
                                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="3" Text='<%#Eval("Amount") %>'
                                                    Width="100" ReadOnly="true"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="fEarn3" runat="server" FilterMode="ValidChars" FilterType="Numbers, Custom"
                                                    TargetControlID="txtAmount" ValidChars=".">
                                                </cc1:FilteredTextBoxExtender>
                                                <asp:RequiredFieldValidator ID="req1" runat="server" ControlToValidate="txtAmount"
                                                    Display="Dynamic" ErrorMessage="*" SetFocusOnError="true" ValidationGroup="save1"></asp:RequiredFieldValidator>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Type">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblCalType" runat="server" Text='<%#Eval("CalType") %>'></asp:Label>
                                                <asp:Label ID="lblRemunerationType" runat="server" Text='<%#Eval("RemunerationType") %>'
                                                    Visible="false"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="false">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            <ItemTemplate>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lbl" runat="server" Text="CalculateOn" Visible="false"></asp:Label>
                                                        </td>
                                                        <td style="width: 100%">
                                                            <asp:RadioButtonList ID="rbtnCalOn" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"
                                                                ToolTip=" <%# Container.DataItemIndex %>" Visible="false" Width="100%">
                                                                <asp:ListItem Selected="true" Text="Basic" Value="Basic"></asp:ListItem>
                                                                <asp:ListItem Text="FixAmount" Value="FixAmount"></asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                        <td></td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="false">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtPerCalAmount" runat="server" Text='<%#Eval("Per_Cal_Amt") %>'
                                                    Visible="false" Width="100"></asp:TextBox>
                                                <asp:Label ID="lblPerCalOn" runat="server" Text='<%#Eval("Per_Cal_on") %>' Visible="False"></asp:Label>
                                                <cc1:FilteredTextBoxExtender ID="fEarn" runat="server" FilterMode="ValidChars" FilterType="Numbers, Custom"
                                                    TargetControlID="txtPerCalAmount" ValidChars=".">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Probation Period
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtProbation" runat="server" onkeypress="return check(event)"
                                    onkeyup="validatespace();" ToolTip="Enter Probation Period" Width="68%"></asp:TextBox>
                                Months
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterMode="ValidChars"
                                FilterType="Numbers,Custom" TargetControlID="txtProbation">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Authority Designation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAuthorityDesignation" runat="server"
                                    ToolTip="Enter Authority Designation"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Terminate App.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtTeminate" runat="server" onkeypress="return check(event)"
                                    onkeyup="validatespace();" ToolTip="Enter Terminate Appointment" Width="78%"></asp:TextBox>
                                days<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterMode="ValidChars"
                                    FilterType="Numbers,Custom" TargetControlID="txtTeminate">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Authority Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAuthorityDepartment" runat="server"
                                    ToolTip="Enter Authority Department"></asp:TextBox>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                                    ShowSummary="False" ValidationGroup="v1" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAddress"
                                    Display="None" ErrorMessage="Joining Location" SetFocusOnError="True" ValidationGroup="v1"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" CssClass="ItDoseButton" runat="server" OnClick="btnSave_Click"
                    Text="Save" ToolTip="Click to Save" Style="margin-top: 7px; width: 100px" />
                <asp:Button ID="btnUpdate" CssClass="ItDoseButton" runat="server" Text="Update" OnClick="btnUpdate_Click"
                    ToolTip="Click to Update" Style="margin-top: 7px; width: 100px" />
                <asp:Button ID="btncancel" CssClass="ItDoseButton" runat="server" Text="Cancel" OnClick="btncancel_Click"
                    ToolTip="Click to Cancel" Style="margin-top: 7px; width: 100px" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
