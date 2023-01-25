<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPD_ConsentForm.aspx.cs" Inherits="IPD_ConsentForm" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }

        $(document).ready(function () {
            $("#txtWitnessName,#txtRelativeName,#txtRelWitnessName").keyup(function () {
                var Name = $(this).val();
                if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',' || Name.charAt(0) == '0' || Name.charAt(0) == '-') {
                    $(this).val('');
                    Name.replace(Name.charAt(0), "");
                    return false;
                }
            });
        });
    </script>
    <script type="text/javascript">

        function validate() {

            if ($("#ddlSurgery").val() == 0) {
                $("#lblMsg").text("Please Select Surgery.");
                $("#ddlSurgery").focus();
                return false;
            }
            else if ($.trim($("#txtConsentDate").val()).length == 0) {
                $("#lblMsg").text("Please Enter Consent Date.");
                $("#txtConsentDate").focus();
                return false;
            }
            else if ($.trim($("#txtWitnessName").val()).length == 0) {
                $("#lblMsg").text("Please Enter Witness Name.");
                $("#txtWitnessName").focus();
                return false;
            }
            else if ($.trim($("#txtRelativeName").val()).length == 0) {
                $("#lblMsg").text("Please Enter Relative Name.");
                $("#txtRelativeName").focus();
                return false;
            }
            else if ($.trim($("#txtRelConsentDate").val()).length == 0) {
                $("#lblMsg").text("Please Enter Relative Consent Date.");
                $("#txtRelConsentDate").focus();
                return false;
            }
            else if ($.trim($("#txtRelWitnessName").val()).length == 0) {
                $("#lblMsg").text("Please Enter Relative Witness Name.");
                $("#txtRelWitnessName").focus();
                return false;
            }

        }
    </script>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Consent for Operation Form</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Consent By Patient
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Surgery</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList ID="ddlSurgery" runat="server" Width="" ClientIDMode="Static" CssClass="requiredField">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Consent Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="txtConsentDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select Date" Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="calConsentDate" TargetControlID="txtConsentDate" Format="dd-MMM-yyyy" runat="server" BehaviorID="calConsentDate">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Witness Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlWitnessTitle" runat="server" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtWitnessName" runat="server" Width="" ClientIDMode="Static" onkeypress="return check(this,event)" MaxLength="50"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            <div class="Purchaseheader" style="text-align: left;">
                Consent By Relative
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Relative Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlRelTitle" runat="server" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRelativeName" runat="server" Width="" ClientIDMode="Static" onkeypress="return check(this,event)" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Relative Consent Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtRelConsentDate" runat="server" ToolTip="Click to Select Date" ClientIDMode="Static" Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="calConsentDate2" TargetControlID="txtRelConsentDate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Relative Witness Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlRelWitnessTitle" runat="server" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRelWitnessName" runat="server" Width="" ClientIDMode="Static" onkeypress="return check(this,event)" MaxLength="50"></asp:TextBox>

                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return validate()" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="ItDoseButton" OnClick="btnUpdate_Click" />
            </div>
            <asp:Panel runat="server" Visible="false" ID="hide">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Consent Details &nbsp;&nbsp;<span style="background-color: LightGreen">
                        &nbsp;Document Uploaded</span>&nbsp;&nbsp; <span style="background-color: LightPink">Document Not Uploaded</span><br />
                        <asp:Label ID="Label1" runat="server" Text="Note : Only pdf,jpg,jpeg,doc,docx,gif file accepted."></asp:Label>
                    </div>
                </div>
            </asp:Panel>
        </div>
        <div>
            <asp:GridView ID="grdDataView" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="grdDataView_RowCommand" OnRowDataBound="grdDataView_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="EditRow"
                                ImageUrl="~/Images/edit.png" CommandArgument='<%# Eval("ID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Print" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="Print"
                                ImageUrl="~/Images/Print.gif" CommandArgument='<%# Eval("ID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="SurgeryName" HeaderText="Surgery Name">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ConsentDate" HeaderText="Consent Date">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="WitnessName" HeaderText="Witness Name">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="RelName" HeaderText="Relative Name">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="RelConsentDate" HeaderText="Consent Date(R)">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="RelWitnessName" HeaderText="Witness Name(R)">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CreatedBy" HeaderText="Created By">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CreatedDate" HeaderText="Created Date">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DocumentName" HeaderText="File Name">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="UploadedDate" HeaderText="Uploaded Date">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Upload">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemTemplate>
                            <asp:FileUpload ID="ddlupload_doc" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Upload" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Button ID="btnUpload" runat="server" CausesValidation="false" CommandName="SaveImage"
                                Text="Upload" CommandArgument='<%# Eval("ID") %>' CssClass="ItDoseButton" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="View">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("UploadStatus")%>' Visible="false"></asp:Label>
                            <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                ToolTip="Click To View Available Document"
                                ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("DocumentURL")  %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        </div>
    </form>
</body>
</html>

