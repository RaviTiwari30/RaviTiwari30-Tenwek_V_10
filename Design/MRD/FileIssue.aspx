<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FileIssue.aspx.cs" Inherits="Design_MRD_FileIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<script type="text/javascript" src="../../Scripts/ScrollableGrid.js"></script>
<link href="../../Styles/grid24.css" rel="stylesheet" />
<link href="../../Styles/CustomStyle.css" rel="stylesheet" />
<link href="../../Styles/framestyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>
<script type="text/javascript">
    ////    function chkSelectAll(fld) {
    ////        var gridTable = document.getElementById("<%=grdDocs.ClientID %>");
    ////        var chkList = gridTable.document.getElementsByTagName("input");
    ////        for (var i = 0; i < chkList.length; i++) {
    ////            if (chkList[i].type == "checkbox") {
    ////                chkList[i].checked = fld.checked;
    ////            }
    ////        }
    ////    }
    $(document).ready(function () {
        var MaxLength = 100;
        $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
            event.preventDefault();
        });
        $('#<%=txtRemarks.ClientID%>').bind("keypress", function (e) {
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
    function validate() {

        if ($("#<%=cmbDept.ClientID %>").is(':visible') && $("#<%=cmbDept.ClientID %>  option:selected").text() == "Select") {
            modelAlert('Please Select Department');
            $("#<%=cmbDept.ClientID %>").focus();
            return true;

        }
        if ($("#<%=ddlIssueTo.ClientID %>").is(':visible') && $("#<%=ddlIssueTo.ClientID %> option:selected").text() == "Select") {
            modelAlert('Please Select Issue To');
            $("#<%=ddlIssueTo.ClientID %>").focus();
            return false;

        }
        if ($("#<%=txtRemarks.ClientID %>").val() == "") {
            modelAlert('Please Enter Remarks');
            $("#<%=txtRemarks.ClientID %>").focus();
            return false;
        }
        if ($("#<%=txtissueTo.ClientID %>").is(':visible') && $("#<%=txtissueTo.ClientID %>").val() == "") {
            modelAlert('Please Enter Issue To ');
            $("#<%=txtissueTo.ClientID %>").focus();
            return false;
        }
        if ($("#<%=txtissueTo.ClientID %>").is(':visible') && $("#<%=txtissueTo.ClientID %>").val() == "") {
            modelAlert('Please Enter Issue Department ');
            $("#<%=txtissueTo.ClientID %>").focus();
            return false;
        }
        if (Page_IsValid) {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
        else {
            document.getElementById('<%=btnSave.ClientID%>').disabled = false;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
        }

    }
    $(document).ready(function () {
        $("#<%=EntryTime1.ClientID %>").keypress(function (e) {
            var regex = ["[0-2]", "[0-4]", ":", "[0-6]", "[0-9]", "(A|P)", "M"],
    string = $(this).val() + String.fromCharCode(e.which),
    b = true;
            for (var i = 0; i < string.length; i++) {
                if (!new RegExp("^" + regex[i] + "$").test(string[i])) {
                    b = false;
                }
            }
            return b;
        });

    });
    //    $(function () {
    //        $('#<%=grdDocs.ClientID %>').Scrollable();
    //    });
</script>
<script type="text/javascript">
    $("[id*=chkSelectAll]").live("click", function () {
        var chkHeader = $(this);
        var grid = $(this).closest("table");
        $("input[type=checkbox]", grid).each(function () {
            if (chkHeader.is(":checked")) {
                $(this).not(":disabled").attr("checked", "checked");

            } else {
                $(this).not(":disabled").removeAttr("checked");

            }
        });
    });
    $("[id*=chkIssueStatus]").live("click", function () {
        var grid = $(this).closest("table");
        var chkHeader = $("[id*=chkSelectAll]", grid);
        if (!$(this).is(":checked")) {
            chkHeader.removeAttr("checked");
        } else {
            if ($("[id*=chkIssueStatus]", grid).not(":disabled").length == $("[id*=chkIssueStatus]:checked", grid).not(":disabled").length) {
                chkHeader.attr("checked", "checked");
            }
        }
    });
    $(document).ready(function () {
        $("#<%=RadioButtonList1.ClientID %> input:radio").change(function () {
            if ($('#<%=RadioButtonList1.ClientID %> input[type=radio]:checked').val() == 'Internal') {
                $('#<%=lblIssueExt.ClientID %>').hide();
                $('#<%=txtissueTo.ClientID %>').hide();
                $('#<%=lblIssueDeptExt.ClientID %>').hide();
                $('#<%=txtIssueDeptExt.ClientID %>').hide();
                $('#<%=lblDepartmentExt.ClientID %>').hide();
                $('#<%=lblV3.ClientID %>').hide();
                $('#<%=lblV4.ClientID %>').hide();
                $('#<%=lblIssueInt.ClientID %>').show();
                $('#<%=ddlIssueType.ClientID %>').show();
                $('#<%=ddlIssueTo.ClientID %>').show();
                $('#<%=cmbDept.ClientID %>').show();
                $('#<%=lblDepartment.ClientID %>').show();
                $('#<%=lblUser.ClientID %>').show();
                $('#<%=lblV1.ClientID %>').show();
                $('#<%=lblV2.ClientID %>').show();
            }
            else {
                $('#<%=lblDepartmentExt.ClientID %>').hide();
                $('#<%=lblIssueInt.ClientID %>').hide();
                $('#<%=ddlIssueType.ClientID %>').hide();
                $('#<%=ddlIssueTo.ClientID %>').hide();
                $('#<%=lblUser.ClientID %>').hide();
                $('#<%=cmbDept.ClientID %>').hide();
                $('#<%=lblDepartment.ClientID %>').hide();
                $('#<%=lblV1.ClientID %>').hide();
                $('#<%=lblV2.ClientID %>').hide();
                $('#<%=lblIssueExt.ClientID %>').show();
                $('#<%=txtissueTo.ClientID %>').show();
                $('#<%=lblIssueDeptExt.ClientID %>').show();
                $('#<%=txtIssueDeptExt.ClientID %>').show();
                $('#<%=lblV3.ClientID %>').show();
                $('#<%=lblV4.ClientID %>').show();
            }
        });
    });
    $(document).ready(function () {
        $("#<%=rdbIssueType.ClientID %> input:radio").change(function () {
            if ($('#<%=rdbIssueType.ClientID %> input[type=radio]:checked').val() == 'Internal') {
                $('#<%=lblIssueExt.ClientID %>').hide();
                $('#<%=txtissueTo.ClientID %>').hide();
                $('#<%=lblIssueDeptExt.ClientID %>').hide();
                $('#<%=txtIssueDeptExt.ClientID %>').hide();
                $('#<%=lblDepartmentExt.ClientID %>').hide();
                $('#<%=lblV3.ClientID %>').hide();
                $('#<%=lblV4.ClientID %>').hide();
                $('#<%=lblIssueInt.ClientID %>').show();
                $('#<%=ddlIssueType.ClientID %>').show();
                $('#<%=ddlIssueTo.ClientID %>').show();
                $('#<%=cmbDept.ClientID %>').show();
                $('#<%=lblDepartment.ClientID %>').show();
                $('#<%=lblUser.ClientID %>').show();
                $('#<%=lblV1.ClientID %>').show();
                $('#<%=lblV2.ClientID %>').show();
            }
            else {
                $('#<%=lblDepartmentExt.ClientID %>').hide();
                $('#<%=lblIssueInt.ClientID %>').hide();
                $('#<%=ddlIssueType.ClientID %>').hide();
                $('#<%=ddlIssueTo.ClientID %>').hide();
                $('#<%=lblUser.ClientID %>').hide();
                $('#<%=cmbDept.ClientID %>').hide();
                $('#<%=lblDepartment.ClientID %>').hide();
                $('#<%=lblV1.ClientID %>').hide();
                $('#<%=lblV2.ClientID %>').hide();
                $('#<%=lblIssueExt.ClientID %>').show();
                $('#<%=txtissueTo.ClientID %>').show();
                $('#<%=lblIssueDeptExt.ClientID %>').show();
                $('#<%=txtIssueDeptExt.ClientID %>').show();
                $('#<%=lblV3.ClientID %>').show();
                $('#<%=lblV4.ClientID %>').show();
            }
        });
    });
    $(document).ready(function () {
        show();
    });
    function show() {
        if ($('#<%=RadioButtonList1.ClientID %> input[type=radio]:checked').val() == 'Internal') {
            $('#<%=lblIssueExt.ClientID %>').hide();
            $('#<%=txtissueTo.ClientID %>').hide();
            $('#<%=lblIssueDeptExt.ClientID %>').hide();
            $('#<%=txtIssueDeptExt.ClientID %>').hide();
            $('#<%=lblDepartmentExt.ClientID %>').hide();
            $('#<%=lblV3.ClientID %>').hide();
            $('#<%=lblV4.ClientID %>').hide();
            $('#<%=lblIssueInt.ClientID %>').show();
            $('#<%=ddlIssueType.ClientID %>').show();
            $('#<%=ddlIssueTo.ClientID %>').show();
            $('#<%=cmbDept.ClientID %>').show();
            $('#<%=lblDepartment.ClientID %>').show();
            $('#<%=lblUser.ClientID %>').show();
            $('#<%=lblV1.ClientID %>').show();
            $('#<%=lblV2.ClientID %>').show();
        }
        else if ($('#<%=rdbIssueType.ClientID %> input[type=radio]:checked').val() == 'Internal') {
            $('#<%=lblIssueExt.ClientID %>').hide();
            $('#<%=txtissueTo.ClientID %>').hide();
            $('#<%=lblIssueDeptExt.ClientID %>').hide();
            $('#<%=txtIssueDeptExt.ClientID %>').hide();
            $('#<%=lblDepartmentExt.ClientID %>').hide();
            $('#<%=lblV3.ClientID %>').hide();
            $('#<%=lblV4.ClientID %>').hide();
            $('#<%=lblIssueInt.ClientID %>').show();
            $('#<%=ddlIssueType.ClientID %>').show();
            $('#<%=ddlIssueTo.ClientID %>').show();
            $('#<%=cmbDept.ClientID %>').show();
            $('#<%=lblDepartment.ClientID %>').show();
            $('#<%=lblUser.ClientID %>').show();
            $('#<%=lblV1.ClientID %>').show();
            $('#<%=lblV2.ClientID %>').show();
        }
        else {
            $('#<%=lblDepartmentExt.ClientID %>').hide();
            $('#<%=lblIssueInt.ClientID %>').hide();
            $('#<%=ddlIssueType.ClientID %>').hide();
            $('#<%=ddlIssueTo.ClientID %>').hide();
            $('#<%=lblUser.ClientID %>').hide();
            $('#<%=cmbDept.ClientID %>').hide();
            $('#<%=lblDepartment.ClientID %>').hide();
            $('#<%=lblV1.ClientID %>').hide();
            $('#<%=lblV2.ClientID %>').hide();
            $('#<%=lblIssueExt.ClientID %>').show();
            $('#<%=txtissueTo.ClientID %>').show();
            $('#<%=lblIssueDeptExt.ClientID %>').show();
            $('#<%=txtIssueDeptExt.ClientID %>').show();
            $('#<%=lblV3.ClientID %>').show();
            $('#<%=lblV4.ClientID %>').show();
        }


}
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .auto-style1 {
            width: 270px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="margin-top: 0px;">
            <Ajax:ScriptManager ID="sp" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory">
                <div class="">
                    <div style="text-align: center;">
                        <b>File Issue</b><br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                        <%--                    <asp:Label ID="lblStatus" runat="server" Font-Bold="True" CssClass="ItDoseLblError"></asp:Label>
                        --%>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <asp:Panel ID="pnlIPD" runat="server" Visible="false">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        IPD No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblCRNumber" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Patient Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        MLC Number
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblMLCNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Bill No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblBillNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Dis. Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblDischargeDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Shelf No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblShelf" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                    <asp:Label ID="lblroomid" runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblAlmid" runat="server" Visible="false"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        File No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlFileID" runat="server" Width="" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlFileID_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        File Reg. Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblFileRegisterDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3" style="display: none;">
                                    <label class="pull-left">
                                        Position No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5" style="display: none;">
                                    <asp:Label ID="lblPosition" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Rack Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblAlmirah" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-5">
                                    <asp:RadioButtonList RepeatDirection="Horizontal" runat="server" ID="rdbIssueType">
                                        <asp:ListItem Selected="True" Text="Internal" Value="Internal"></asp:ListItem>
                                        <asp:ListItem Text="External" Value="External"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlOpd" runat="server" Visible="false">
                    <table>
                        <tr>
                            <td align="right" style="width: 110px;">UHID :&nbsp;
                            </td>
                            <td align="left" style="width: 200px;">
                                <asp:Label ID="lblMrno" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td align="right" style="width: 200px">Patient Name :&nbsp;
                            </td>
                            <td align="left" style="width: 200px">
                                <asp:Label ID="lblpName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td align="right" style="width: 200px">Shelf No. :</td>
                            <td align="left" style="width: 200px">

                                <asp:Label ID="lblshelfid" runat="server" CssClass="ItDoseLabelSp"></asp:Label>

                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 110px;">File No. :&nbsp;</td>
                            <td align="left" style="width: 200px; height: 18px;">

                                <asp:DropDownList ID="ddlfile" runat="server" Width="173px" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlFileID_SelectedIndexChanged">
                                </asp:DropDownList>

                            </td>
                            <td align="right" style="width: 200px; display: none; height: 18px;">Position No. :&nbsp;</td>
                            <td align="left" style="width: 200px; display: none; height: 18px;">

                                <asp:Label ID="lblpositionno" runat="server" CssClass="ItDoseLabelSp"></asp:Label>

                            </td>
                            <td align="right" style="width: 200px; height: 18px;">&nbsp;
                            </td>
                            <td align="left" style="width: 200px">
                                <asp:Label ID="lblalm" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblroom" runat="server" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 110px;">Rack Name :&nbsp;</td>
                            <td align="left" style="width: 200px">
                                <asp:Label ID="lblrack" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td align="right" style="width: 200px">File&nbsp;Registration&nbsp;Date&nbsp;:&nbsp;</td>
                            <td align="left" style="width: 200px">

                                <asp:Label ID="lblFileRegisterDate0" runat="server" CssClass="ItDoseLabelSp"></asp:Label>

                            </td>
                            <td align="right" style="width: 200px">&nbsp;
                            </td>
                            <td align="left" style="width: 200px">&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 110px;">&nbsp;
                            </td>
                            <td align="left" style="width: 200px;">&nbsp;</td>
                            <td align="center" colspan="2">
                                <asp:RadioButtonList RepeatDirection="Horizontal" runat="server" ID="RadioButtonList1">
                                    <asp:ListItem Selected="True" Text="Internal" Value="Internal"></asp:ListItem>
                                    <asp:ListItem Text="External" Value="External"></asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td align="left" style="width: 200px;">&nbsp;
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <table width="100%">
                    <tr align="center">
                        <td>
                            <div style="overflow: auto; padding: 3px; width: 100%; height: 224px;">
                                <asp:GridView ID="grdDocs" runat="server" Width="100%" AutoGenerateColumns="False" OnRowDataBound="grdDocs_RowDataBound">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>

                                        <asp:TemplateField HeaderText="Issue">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" Visible="false" Checked="true" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkIssueStatus" runat="server" Checked='true'
                                                    Enabled='false' Visible="false" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFileDetID" Text='<%#Eval("FileDetID") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIssueStatus" Text='<%#Eval("IsIssued") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="File No.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFileID" Text='<%#Eval("FileID") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Document">
                                            <ItemTemplate>
                                                <asp:Label ID="lblName" Text='<%#Eval("Name") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDocID" Text='<%#Eval("DocumentID") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Issue Type">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIssueType" Text='<%#Eval("IssueType") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Issue To" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIssueTo" Text='<%#Eval("Issue_To") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Issue To Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIssueToName" Text='<%#Eval("Issue_To_Name") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Department">
                                            <ItemTemplate>
                                                <asp:Label ID="lbldepartment" Text='<%#Eval("department") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Issue By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIssueBy" Text='<%#Eval("EmpName") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Issue Date & Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIssueDate" Text='<%#Eval("IssueDate") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSTATUS" Text='<%#Eval("STATUS") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                </table>
                <Ajax:UpdatePanel ID="up" runat="server">
                    <ContentTemplate>
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            <asp:Label ID="lblIssueExt" runat="server" Text="Issue To <b>:</b> " Style="display: none"></asp:Label>
                                        </label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtissueTo" runat="server" CssClass="required" Width="" Style="display: none"></asp:TextBox>&nbsp;<asp:Label
                                            ID="lblV3" runat="server" Style="color: Red; font-size: 10px; display: none"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            <asp:Label ID="lblDepartmentExt" runat="server" Text="Department:" Style="display: none;"></asp:Label>
                                          <asp:Label ID="lblIssueDeptExt" Style="display: none" runat="server" Text="Department&nbsp;<b>:</b>&nbsp;"></asp:Label>
                                        </label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtIssueDeptExt" CssClass="requiredField" Width="" Style="display: none" runat="server"></asp:TextBox>
                                        <asp:Label ID="lblV4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            <asp:Label ID="lblIssueInt" runat="server" Text="Type &nbsp;&nbsp;&nbsp;<b>:</b>"></asp:Label>
                                        </label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlIssueType" runat="server" Width="" AutoPostBack="True"
                                            OnSelectedIndexChanged="ddlIssueType_SelectedIndexChanged">
                                            <asp:ListItem>Select</asp:ListItem>
                                            <asp:ListItem>Doctor</asp:ListItem>
                                            <asp:ListItem>Employee</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            <asp:Label ID="lblDepartment" runat="server" Text="Department&nbsp;&nbsp;&nbsp;<b>:</b>"></asp:Label>
                                        </label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="cmbDept" CssClass="requiredField" runat="server" Width="" AutoPostBack="True" OnSelectedIndexChanged="cmbDept_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:Label ID="lblV1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                        <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="cmbDept"
                                            ValidationGroup="doc" InitialValue="0" ErrorMessage="Please Select Department" Display="None"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            <asp:Label ID="lblUser" runat="server" Text="Issued To&nbsp;&nbsp;&nbsp;<b>:</b>"></asp:Label>
                                        </label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlIssueTo" CssClass="requiredField" runat="server" Width="">
                                        </asp:DropDownList>
                                        <asp:Label ID="lblV2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Issue Date
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="EntryDate1" runat="server" Width=""></asp:TextBox>
                                        <cc1:CalendarExtender ID="calucDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                                        </cc1:CalendarExtender>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Issue&nbsp;Time
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="EntryTime1" runat="server" Width=""></asp:TextBox>
                                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                            TargetControlID="EntryTime1" AcceptAMPM="true">
                                        </cc1:MaskedEditExtender>
                                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="EntryTime1"
                                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                        <br />
                                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Return Time
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        Days&nbsp;<asp:DropDownList ID="ddldays" runat="server" Width="50px">
                                        </asp:DropDownList>
                                        Hrs&nbsp;<asp:DropDownList ID="ddlHours" runat="server" Width="50px">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Copy Type</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:CheckBox ID="chkHardCopy" runat="server" Text="HardCopy"/>
                                        <asp:CheckBox ID="chkSoftCopy" runat="server" Text="SoftCopy"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Req.Remarks</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label runat="server" ID="lblHardCopyRemarks"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Remarks
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtRemarks" runat="server" CssClass="requiredField" ToolTip="Enter Remarks" TextMode="MultiLine"
                                            Width=""></asp:TextBox>
                                        <asp:Label ID="lblV5" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>

                    </ContentTemplate>
                    <Triggers>
                        <Ajax:AsyncPostBackTrigger ControlID="ddlIssueType" EventName="SelectedIndexChanged" />
                        <Ajax:AsyncPostBackTrigger ControlID="cmbDept" EventName="SelectedIndexChanged" />
                    </Triggers>
                </Ajax:UpdatePanel>
                <Ajax:UpdateProgress ID="UpdateProgress1" AssociatedUpdatePanelID="up" runat="server">
                    <ProgressTemplate>
                        Processing...
                    </ProgressTemplate>
                </Ajax:UpdateProgress>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" Text="Save" CssClass="ItDoseButton" runat="server" OnClick="btnSave_Click" CausesValidation="false"
                    ValidationGroup="doc" OnClientClick="return validate();" />
                <asp:Button ID="btnBack" Text="Back" CssClass="ItDoseButton" runat="server" OnClick="btnBack_Click"
                    ValidationGroup="doc" Visible="false" />
            </div>
        </div>
    </form>
</body>
</html>
