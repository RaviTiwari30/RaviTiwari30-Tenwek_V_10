<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Confirmation_Letter.aspx.cs" Inherits="Design_Payroll_Confirmation_Letter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
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
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Probation Confirmation Letter </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">
                                Probation Confirmation Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btmSubmit" runat="server" Text="Search" OnClick="btmSubmit_Click"
                                CssClass="ItDoseButton" ToolTip="Click to Search" />
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
                    <div class="col-md-24" align="center">
                        <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                            OnRowCommand="grirecord_RowCommand" OnRowDataBound="EmpGrid_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee&nbsp;ID" Visible="true">
                                    <ItemTemplate>
                                        <asp:Label ID="lblid" runat="server" Text='<%#Eval("EmployeeID")%>' Visible="true"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee&nbsp;Name">
                                    <ItemTemplate>
                                        <%#Eval("Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation">
                                    <ItemTemplate>
                                        <%#Eval("Desi_Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department">
                                    <ItemTemplate>
                                        <%#Eval("Dept_Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="D.O.J.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDOJ" runat="server" Text='<%#Eval("DOJ") %>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Confirm&nbsp;Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblConfirmDate" runat="server" Text="Label"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Probation&nbsp;Period">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProbationPeriodComplet" Text='<%#Eval("ProbationPeriodCompleteDate") %>'
                                            Visible="False" runat="server"></asp:Label>
                                        <asp:Label ID="lblEmployeeID" Visible="False" runat="server" Text='<%#Eval("EmployeeID") %>'></asp:Label>
                                        <asp:Label ID="lblprobationperiod" Visible="true" runat="server" Text='<%#Eval("ProbationPeriod") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Select">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>' CommandName="Select" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbPrint" ToolTip="Click to Print" runat="server" ImageUrl="~/Images/Print.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>' Visible='<%# Util.GetBoolean(Eval("Print")) %>'
                                            CommandName="Print" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">

                <table border="0" style="width: 700px">
                    <tr>
                        <td align="center" colspan="5">
                            <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" BackgroundCssClass="filterPupupBackground"
                                CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle"
                                TargetControlID="btnHidden" BehaviorID="mpeCreateGroup">
                            </cc1:ModalPopupExtender>
                            <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
                                <div id="dragUpdate" runat="server" class="Purchaseheader">
                                    &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                                        &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
                                        Press esc to close
                                </div>
                                <div class="row">
                                    <div class="col-md-22" align="center">
                                        <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-22">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Employee Id
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:Label ID="lblEmployeeid" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
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
                                                    Designation
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:Label ID="lblDesigantion" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
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
                                                <asp:Label ID="lblProbation" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Issue Date
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:TextBox ID="txtissuedate" runat="server" ToolTip="Select Issue Date" TabIndex="1"></asp:TextBox>
                                                <cc1:CalendarExtender ID="calissuedate" runat="server" TargetControlID="txtissuedate"
                                                    Format="dd-MMM-yyyy">
                                                </cc1:CalendarExtender>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Gross Salary
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:TextBox ID="txtgrossslry" runat="server" TabIndex="2" ToolTip="Enter Gross Salary"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbsalary" runat="server" FilterMode="validChars"
                                                    FilterType="Custom, numbers" TargetControlID="txtgrossslry" ValidChars=".">
                                                </cc1:FilteredTextBoxExtender>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Authority Name
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:TextBox ID="txtAuthorityname" runat="server" TabIndex="3" MaxLength="100" ToolTip="Enter Authority Name" CssClass="requiredField"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqAuthorityName" runat="server" ControlToValidate="txtAuthorityname"
                                                    Display="None" ErrorMessage="Enter Authority Name" SetFocusOnError="True" ValidationGroup="save"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Authority Deg.
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:TextBox ID="txtauthoritydesig" runat="server" MaxLength="50" TabIndex="4" ToolTip="Enter Authority Designation" CssClass="requiredField"></asp:TextBox>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Authority Dept.
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:TextBox ID="txtAuthorityDepartment" runat="server" MaxLength="50" TabIndex="5" ToolTip="Enter Authority Department"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="pull-left">
                                                    Branch Name
                                                </label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <asp:TextBox ID="txtHospitalname" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                        </div>
                                        <div class="row">
                                            <div class="col-md-24" align="center">
                                                <asp:Button ID="Button1" ValidationGroup="save" runat="server" OnClick="btnSave_Click"
                                                    Text="Save" CssClass="ItDoseButton" ToolTip="Click to Save" TabIndex="6" Style="margin-top: 7px; width: 100px" OnClientClick="return validate();" />
                                                <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="ItDoseButton" TabIndex="7"
                                                    ToolTip="Click to Cancel" Style="margin-top: 7px; width: 100px" />
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
                <br />
            </div>
            <div style="display: none;">
                <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
            </div>
        </div>
    </div>
    <script>
        function validate() {
            if ($('#<%=txtAuthorityname.ClientID%>').val() == "")
            {
                $('#lblmsgpopup').text('Please Enter Authority Name');
                $('#<%=txtAuthorityname.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtauthoritydesig.ClientID%>').val() == "") {
                $('#lblmsgpopup').text('Please Enter Authority Designation');
                $('#<%=txtauthoritydesig.ClientID%>').focus();
                return false;
            }


        }

    </script>
</asp:Content>
