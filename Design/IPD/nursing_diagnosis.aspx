<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nursing_diagnosis.aspx.cs" Inherits="Design_IPD_nursing_diagnosis" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <style type="text/css">
        .auto-style1 {
            width: 108px;
            text-align: right;
        }

        .auto-style2 {
            width: 140px;
            text-align: right;
        }
    </style>
    <script type="text/javascript">
        var openDivCreateGroup = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#divCreateGroup');
            divSearchbyDate.showModel();
        }

        var openDivCreateDiagnosis = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#divCreateDiagnosis');
            divSearchbyDate.showModel();
        }

        var validateGroupName = function (e) {

            if ($.trim($('#txtGroupName').val()) == '') {
                modelAlert('Enter Group Name');
                $('#txtGroupName').focus();
                return false;
            }

            __doPostBack('btnNewGroupPopUp', '');
        }

        var validateDiagnosisName = function (e) {

            if ($('#ddlGroupNamePopup Option').length == 0) {
                modelAlert('Please Select Group Name');
                $('#ddlGroupNamePopup Option').focus();
                return false;
            }

            if ($.trim($('#txtDiagnosisName').val()) == '') {
                modelAlert('Enter Diagnosis Name');
                $('#txtDiagnosisName').focus();
                return false;
            }

            __doPostBack('btnSaveDiagnosis', '');
        }

        var validateNursingDiagnosis = function (e) {

            if ($('#ddlGroupName Option').length == 0) {
                modelAlert('Please Select Group Name');
                $('#ddlGroupName Option').focus();
                return false;
            }

            if ($('#ddlDiagnosisName Option').length == 0) {
                modelAlert('Please Select Diagnosis Name');
                $('#ddlDiagnosisName Option').focus();
                return false;
            }

            __doPostBack('btnSave', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="sm1" runat="server" />
        <div id="Pbody_box_inventory" style="text-align: center;">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>NANDA Nursing Diagnosis</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">Group Name :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlGroupName" runat="server" Width="200px" TabIndex="1" OnSelectedIndexChanged="ddlGroupName_SelectedIndexChanged" AutoPostBack="true" ClientIDMode="Static"></asp:DropDownList>
                            <asp:Button ID="btnNewGroupPopUp" CssClass="ItDoseButton" runat="server" Text="New" OnClientClick="openDivCreateGroup(event);" />
                        </td>
                        <td style="text-align: right">Diagnosis Name :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlDiagnosisName" runat="server" Width="200px" TabIndex="2" ClientIDMode="Static"></asp:DropDownList>
                            <asp:Button ID="btnNewDiagnosisPopUp" CssClass="ItDoseButton" runat="server" Text="New" OnClientClick="openDivCreateDiagnosis(event);" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center" colspan="4">
                            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" TabIndex="3" ClientIDMode="Static" OnClick="btnSave_Click" OnClientClick="return validateNursingDiagnosis(event);" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Patient Nursing Diagnosis
                </div>
                <asp:GridView ID="grdDiagnosis" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" OnRowDeleting="grid_RowDeleting">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="GroupName" HeaderText="Group Name" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="Diagnosis" HeaderText="Diagnosis Name" HeaderStyle-Width="400px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="EntryBy" HeaderText="Entry By" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:CommandField ShowDeleteButton="True" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image" DeleteText="Remove Procedure" DeleteImageUrl="~/Images/Delete.gif" />
                    </Columns>
                </asp:GridView>
                <br />
            </div>
        </div>

        <div id="divCreateGroup" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 200px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divCreateGroup" area-hidden="true">&times;</button>
                        <b class="modal-title">Create New Group</b>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-12">
                                        <label class="pull-left">Group Name</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-12">
                                        <asp:TextBox ID="txtGroupName" class="requiredField" runat="server" ToolTip="Enter Group Name" ClientIDMode="Static" MaxLength="100" Width="100%"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnSaveGroupName" Text="Save" runat="server" OnClick="btnSaveGroupName_Click" OnClientClick="return validateGroupName(event);" />
                        <button type="button" data-dismiss="divCreateGroup">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="divCreateDiagnosis" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 400px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divCreateDiagnosis" area-hidden="true">&times;</button>
                        <b class="modal-title">Create New Diagnosis</b>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-10">
                                        <label class="pull-left">Group Name</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-14">
                                        <asp:DropDownList ID="ddlGroupNamePopup" class="requiredField" ToolTip="Select Group Name" runat="server" Width="100%" ClientIDMode="Static"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-10">
                                        <label class="pull-left">Diagnosis Name</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-14">
                                        <asp:TextBox ID="txtDiagnosisName" class="requiredField" runat="server" ToolTip="Enter Diagnosis Name" ClientIDMode="Static" Width="100%" MaxLength="100"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnSaveDiagnosis" Text="Save" runat="server" OnClick="btnSaveDiagnosis_Click" OnClientClick="return validateDiagnosisName(event);" />
                        <button type="button" data-dismiss="divCreateDiagnosis">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
