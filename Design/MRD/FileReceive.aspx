<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FileReceive.aspx.cs" Inherits="Design_MRD_FileReceive" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/ScrollableGrid.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<link href="../../Styles/CustomStyle.css" rel="stylesheet" />
<link href="../../Styles/grid24.css" rel="stylesheet" />
<link href="../../Styles/framestyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>
<script type="text/javascript">
    //    function chkSelectAll(fld) {
    //        var gridTable = document.getElementById("<%=grdDocs.ClientID %>");
    //        var chkList = gridTable.document.getElementsByTagName("input");
    //        for (var i = 0; i < chkList.length; i++) {
    //            if (chkList[i].type == "checkbox") {
    //                chkList[i].checked = fld.checked;
    //            }
    //        }
    //    }
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
    $("[id*=chkReturnStatus]").live("click", function () {
        var grid = $(this).closest("table");
        var chkHeader = $("[id*=chkSelectAll]", grid);
        if (!$(this).is(":checked")) {
            chkHeader.removeAttr("checked");
        } else {
            if ($("[id*=chkReturnStatus]", grid).not(":disabled").length == $("[id*=chkReturnStatus]:checked", grid).not(":disabled").length) {
                chkHeader.attr("checked", "checked");
            }
        }
    });
    function validate() {
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

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .style1 {
            width: 964px;
        }

        .style3 {
            width: 325px;
        }

        .style4 {
            width: 266px;
        }

        .style5 {
            width: 10px;
        }

        .style6 {
            width: 108px;
        }

        .style7 {
            width: 90px;
        }

        .style8 {
            width: 166px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="Pbody_box_inventory" style="margin-top: 0px;">
                <Ajax:ScriptManager ID="sc" runat="server">
                </Ajax:ScriptManager>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>File Receive</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
                <div class="POuter_Box_Inventory">
                    <asp:Panel ID="pnlIpd" runat="server" Visible="false">
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
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlOpd" runat="server" Visible="false">
                        <table>
                            <tr>
                                <td style="width: 200px; text-align: right;">UHID :&nbsp;
                                </td>
                                <td align="left" style="width: 200px">
                                    <asp:Label ID="lblMRno" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </td>
                                <td style="width: 200px; text-align: right;">Patient Name :&nbsp;
                                </td>
                                <td>
                                    <asp:Label ID="lblPnatientnameOpd" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <table width="100%">
                        <tr align="center">
                            <td>
                                <div style="overflow: auto; padding: 3px; width: 100%; height: 274px;">
                                    <asp:GridView ID="grdDocs" runat="server" AutoGenerateColumns="False" Width="100%" OnRowDataBound="grdDocs_RowDataBound">
                                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                        <Columns>
                                            <asp:TemplateField Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDetailId" Text='<%#Eval("FileDetID") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="GridViewItemStyle" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:TemplateField Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblfileissueid" Text='<%#Eval("file_issue_id") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="GridViewItemStyle" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Return">
                                                <HeaderTemplate>
                                                    <asp:CheckBox ID="chkSelectAll" Visible="false" Checked="true" runat="server" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkReturnStatus" runat="server" Checked='true' Enabled='false'
                                                        Visible="false" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Return" Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblrtnStatus" Text='<%#Eval("IsReturn") %>' runat="server"></asp:Label>
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
                                                <ItemStyle CssClass="GridViewItemStyle" Width="250px" />
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
                                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Issue Date">
                                                <ItemTemplate>
                                                    <%#Eval("IssueDateGrid") %>
                                                    <asp:Label ID="lblIssueDate" Text='<%#Eval("IssueDate") %>' runat="server" Visible="false"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
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
                                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Issue By">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblIssueBy" Text='<%#Eval("EmpName") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="GridViewItemStyle" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
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
                </div>
                <asp:Panel ID="hide" runat="server">
                    <div class="POuter_Box_Inventory">
                        <div class="Purchaseheader">
                            Last File Location
                        </div>
                        <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                         <div class="row">
                            <div class="col-md-5">
                            <label class="pull-left">Room Name</label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-5">
                            <asp:Label ID="lblroom" runat="server" ForeColor="Blue"></asp:Label>
                             </div>
                              <div class="col-md-3">
                            <label class="pull-left">Rack Name</label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-5">
                            <asp:Label ID="lblrack" runat="server" ForeColor="Blue"></asp:Label>
                             </div>
                               <div class="col-md-3">
                            <label class="pull-left">Shelf No</label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-3">
                            <asp:Label ID="lblShelf" runat="server" ForeColor="Blue"></asp:Label>
                             </div>
                         </div>
                            <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left">Return UserName</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div  class="col-md-5">
                                    <asp:Label ID="lblReturnUserName" runat="server" ForeColor="Blue"></asp:Label>
                                </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">Return Dept</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div  class="col-md-5">
                                    <asp:Label ID="lblReturnDept" runat="server" ForeColor="Blue"></asp:Label>
                                </div>

                            </div>
                        </div>
                            
                        <div class="col-md-1"></div>
                        </div>
                        
                    </div>
                </asp:Panel>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Location
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Room
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:UpdatePanel ID="UpdtpnlRoom" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="cmbRoom" CssClass="requiredField" ToolTip="Select Room" runat="server" Width=""
                                                OnSelectedIndexChanged="cmbRoom_SelectedIndexChanged" AutoPostBack="true" TabIndex="1">
                                            </asp:DropDownList>
                                            <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                            <asp:RequiredFieldValidator ID="reqFileRoom" SetFocusOnError="true" runat="server"
                                                ControlToValidate="cmbRoom" ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Room"
                                                Display="None"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="cmbRoom" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Rack
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:UpdatePanel ID="UpdtpnlAlmirah" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="cmbAlmirah" runat="server" Width="" OnSelectedIndexChanged="cmbAlmirah_SelectedIndexChanged"
                                                AutoPostBack="true" ToolTip="Select Rack" TabIndex="2">
                                            </asp:DropDownList>
                                            <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                            <asp:RequiredFieldValidator ID="reqRack" SetFocusOnError="true" runat="server" ControlToValidate="cmbAlmirah"
                                                ValidationGroup="SaveFile" InitialValue="Select" ErrorMessage="Please Select Rack"
                                                Display="None"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="cmbAlmirah" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Shelf
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:UpdatePanel ID="UpdtpnlShelf" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="cmbShelf" CssClass="requiredField" runat="server" TabIndex="3" Width="" AutoPostBack="true"
                                                OnSelectedIndexChanged="cmbShelf_SelectedIndexChanged" ToolTip="Select Shelf">
                                            </asp:DropDownList>
                                            <asp:Label ID="Label9" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                            <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server"
                                                ControlToValidate="cmbShelf" ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Shelf"
                                                Display="None"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="cmbShelf" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                    <table class="style1">
                        <tr>
                            <td class="style4">
                                <table>
                                    <tr>
                                        <td style="display: none;">
                                            <asp:Label ID="lblFileId" runat="server" Visible="False" Text="Old FileNo. "></asp:Label><asp:Label
                                                ID="lblCounter" runat="server" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" class="style7">
                                <%--For Additional Space in Shelf :&nbsp;--%>
                            </td>
                            <td class="style3">
                                <asp:TextBox ID="txtAdditional" runat="server" Width="147px" Style="display: none;"
                                    MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDots()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fteAdditional" runat="server" TargetControlID="txtAdditional"
                                    ValidChars="." FilterMode="ValidChars" FilterType="Numbers, Custom">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                            <td class="style4">
                                <asp:DropDownList ID="ddlFileNo" runat="server" Visible="False" Width="140px">
                                </asp:DropDownList>
                                <asp:Label ID="lblFileNo" runat="server" Font-Bold="True" Visible="False"></asp:Label>
                            </td>
                            <td class="style5">&nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Iss. Remarks
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-7">
                                    <asp:Label ID="lblIssueRemarks" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Return Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-4">
                                    <asp:TextBox ID="EntryDate1" runat="server" Width=""></asp:TextBox>
                                    <cc1:CalendarExtender ID="calucDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Return Time
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="EntryTime1" runat="server" Width=""></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="EntryTime1" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="EntryTime1"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                    <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                 <label class="pull-left">Copy</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-7">
                                    <asp:CheckBox ID="chkHardCpoy" runat="server" Text="Hard Copy" />  
                                 <asp:CheckBox ID="chkSoftCopy" runat="server" Text="Soft Copy" /> 

                                </div>
                                
                                <div class="col-md-3">
                                 <label class="pull-left">Re.Remarks</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                   <asp:Label ID="lblReturnRemarks" runat="server" CssClass="ItDoseLabelSp"></asp:Label>

                                </div>
                        </div>
                            <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                        Remarks
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Width=""></asp:TextBox>
                                </div>

                            </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>

                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <asp:Button ID="btnSave" Text="Save" CssClass="ItDoseButton" runat="server" OnClick="btnSave_Click" CausesValidation="false" OnClientClick="return validate();"
                        ValidationGroup="doc" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
