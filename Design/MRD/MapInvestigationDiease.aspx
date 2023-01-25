<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MapInvestigationDiease.aspx.cs"
    Inherits="Design_MRD_MapInvestigationDiease" ValidateRequest="false" EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/ScrollableGrid.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<link href="../../Styles/grid24.css" rel="stylesheet" />
<link href="../../Styles/CustomStyle.css" rel="stylesheet" />
<link href="../../Styles/framestyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>
<link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
<script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
<script type="text/javascript" src="../../Scripts/shortcut.js"></script>
<script type="text/javascript" >
    function CancelPopup() {
        $("#<%=txtDisc.ClientID %>").val('');
        $("#<%=Label1.ClientID %>").text('');
        $("#<%=txtDisease.ClientID %>").val('');
    }
    $(document).ready(function () {
        var MaxLength = 100;
        $("#<% =txtDisc.ClientID %>").bind("cut copy paste", function (event) {
            event.preventDefault();
        });
        $('#<%=txtDisc.ClientID%>').bind("keypress", function (e) {
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
    function pageLoad(sender, args) {
        if (!args.get_isPartialLoad()) {
            $addHandler(document, "keydown", onKeyDown);
        }
    }
    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            if ($find("mpe1")) {
                $("#<%=txtDisease.ClientID %>").val('');
                $("#<%=txtDisc.ClientID %>").val('');
                $("#<%=Label1.ClientID %>").text('');
                $find("mpe1").hide();
            }
        }
    }
    function validateDisease() {
        if ($("#<%=txtDisease.ClientID %>").val() == "") {

            //$("#<%=Label1.ClientID %>").text('Please Enter Disease Name');
            modelAlert("Please Enter Disease Name", function () { });
            $("#<%=txtDisease.ClientID %>").focus();
            return false;
        }
        if ($("#<%=txtDisc.ClientID %>").val() == "") {
            //$("#<%=Label1.ClientID %>").text('Please Enter Disease Description');
            modelAlert("Please Enter Disease Description", function () { });
            $("#<%=txtDisc.ClientID %>").focus();
            return false;
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
        //List of special characters you want to restrict
        if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
            return false;
        }

        else {
            return true;
        }
    }
    function validatespace() {
        var Disease = $('#<%=txtDisease.ClientID %>').val();
        if (Disease.charAt(0) == ' ' || Disease.charAt(0) == '.' || Disease.charAt(0) == ',' || Disease.charAt(0) == '0') {
            $('#<%=txtDisease.ClientID %>').val('');
            $("#<%=Label1.ClientID %>").text('First Character Cannot Be Space/Dot');
            Disease.replace(Disease.charAt(0), "");
            return false;
        }
    }


    function validatespaceDes() {
        var DiseaseDesc = $('#<%=txtDisc.ClientID %>').val();
        if (DiseaseDesc.charAt(0) == ' ' || DiseaseDesc.charAt(0) == '.' || DiseaseDesc.charAt(0) == ',' || DiseaseDesc.charAt(0) == '0') {
            $('#<%=txtDisc.ClientID %>').val('');
            $("#<%=Label1.ClientID %>").text('First Character Cannot Be Space/Dot');
            DiseaseDesc.replace(DiseaseDesc.charAt(0), "");
            return false;
        }
    }

    function validate() {
       
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        

    }
    $CreateDisease = function (e) {
        e.preventDefault();
        $('#divCreateDisease').showModel();

    }
</script>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="Scriptmngr" runat="server">
    </asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Map Investigation Disease </b>
            <br />
            <asp:Label ID="lblMSG" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center; width:1036px;">
                <asp:GridView ID="grdMap" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdMap_RowCommand" OnSelectedIndexChanged="grdMap_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Investigation" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblInvestigationname" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField Visible="false" HeaderText="Investigation" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblInvestigationID" runat="server" Text='<%#Eval("Investigation_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disease" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlDisease" runat="server" Width="350px" ToolTip="Select Diagnosis">
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.gif"
                                    CommandArgument='<%#Eval("Test_ID")+"#"+Eval("LedgerTransactionNo")+"#"+Eval("ReportType") %>'
                                    CausesValidation="false" CommandName="View" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Result Flag" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblrsltflg" runat="server" Text='<%#Eval("Result_Flag")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return validate();" CausesValidation="false"/>
                <asp:Button ID="btnShow" runat="server" Text="Create Disease" CssClass="ItDoseButton" OnClientClick="$CreateDisease(event)" ClientIDMode="Static" />
            </div>
        </div>
    </div>
  
    <div style="display: none;">
        <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton"/></div>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none;
        width: 200px; height: 100px;">
        <asp:RadioButtonList ID="rdviewrpt" AutoPostBack="true" runat="server" Width="248px"
            OnSelectedIndexChanged="rdviewrpt_SelectedIndexChanged2">
            <asp:ListItem Value="0">View Report</asp:ListItem>
        </asp:RadioButtonList>
        <table>
            <tr>
                <td style="text-align: center; height: 26px;">
                    &nbsp;<asp:Button ID="btnancl" runat="server" Text="Cancel" CssClass="ItDoseButton"/>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnancl" PopupControlID="Panel2" TargetControlID="Button1" X="150"
        Y="100">
    </cc1:ModalPopupExtender>
         <div id="divCreateDisease" class="modal fade " style="display:none">
             <div class="modal-dialog">
                  <div class="modal-content" style="background-color: white; width: 750px; height: 185px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divCreateDisease" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Create Disease Master</h4>
                    </div>
                      <div class="modal-body">
                            <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22"></div>
                                <div class="row">
                                  <div class="col-md-5">
                                        <label class="pull-left">Disease Name</label>
                                            <asp:Label ID="Label1" runat="server" CssClass="ItDoseLblError" />
                                 <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                         <asp:TextBox ID="txtDisease" MaxLength="50" TabIndex="1" ToolTip="Enter Disease Name"
                                          runat="server" onkeypress="return check(event)" onkeyup="validatespace();" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="pull-left">Disease Description</label>
                                      <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                           <asp:TextBox ID="txtDisc" MaxLength="100" TabIndex="2" ToolTip="Enter Disease Description"
                                            runat="server" TextMode="MultiLine" Width="240px" Height="54px" onkeypress="return check(event)" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="ftbeDesc" runat="server" TargetControlID="txtDisc"
                                             InvalidChars="<>" FilterMode="InvalidChars">
                                            </cc1:FilteredTextBoxExtender>
                                    </div>
                                    </div>
                                <div class="col-md-1"></div>
                                </div>
                          </div>
                      <div class="modal-footer">
                      <div class="row" style="text-align:center">
                     <div class="col-md-24" style="text-align:center">
                          <asp:Button ID="btnSave1" runat="server" Text="Save" TabIndex="3" ToolTip="Click to Save"
                        OnClick="btnSave1_Click" CssClass="ItDoseButton" OnClientClick="return validateDisease();" /> 
                     
                    <asp:Button ID="btnCancel" CssClass="ItDoseButton" runat="server" Text="Cancel" TabIndex="4"
                        ToolTip="Click to Cancel" /> </div>
                      </div>
                      
                      </div>
             </div>
             </div>
    </form>
</body>
</html>
