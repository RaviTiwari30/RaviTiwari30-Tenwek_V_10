<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" ValidateRequest="false"
    AutoEventWireup="true" CodeFile="NewCircular.aspx.cs" Inherits="Design_Circular_NewCircular" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
       #ctl00_ContentPlaceHolder1_txtSearch {margin:5px;
        
        }
    </style>
     <script type="text/javascript" src="../../Scripts/Search.js"></script>  
    <script type="text/javascript">

        function validate() {
            if (Page_IsValid) {
                document.getElementById('<%=btnsave.ClientID%>').disabled = true;
                document.getElementById('<%=btnsave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnsave', '');
            }
            else {
                document.getElementById('<%=btnsave.ClientID%>').disabled = false;
                document.getElementById('<%=btnsave.ClientID%>').value = 'Save';
            }
        }

        function selectDeselect(listbox, checkbox) {
            var select_all = $(checkbox).prop('checked') ? true : false;
            var select = $(listbox);
            if (select_all) {
                var clone = select.clone();
                $('option', clone).attr('selected', select_all);
                var html = clone.html();
                select.html(html);
            }
            else {
                $('option', select).removeAttr('selected');
            }
        }
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lbToList.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<%=txtSearch.ClientID %>').keyup(function (e) {
                searchByInBetween("", "", document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=lbToList.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)

            });
        });
    </script>
    <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Send Circular</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" ></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 100px;"></td>

                    <td align="left" colspan="2">
                        <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                Select&nbsp;Type :&nbsp; 
                                <asp:RadioButtonList ID="rblTo" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rblTo_SelectedIndexChanged"
                                    RepeatDirection="Horizontal" RepeatLayout="Flow" ClientIDMode="Static">
                                    <asp:ListItem Value="1">User</asp:ListItem>
                                    <asp:ListItem Value="0">Department</asp:ListItem>
                                </asp:RadioButtonList>&nbsp;&nbsp;&nbsp;Select All<input type="checkbox" value="Select All" id="chkall" onclick="selectDeselect(lbToList, chkall)" />
                                <br />
                                Search : 
                                <asp:TextBox ID="txtSearch" runat="server" Width="279px" AutoCompleteType="Disabled" ClientIDMode="Static"  onkeyup="if(event.keyCode==13){$('#right').click();};"></asp:TextBox><br />
                                <asp:ListBox ID="lbToList" runat="server" Rows="5" SelectionMode="Multiple" Width="355px" Height="90px" ClientIDMode="Static" onkeyup="if(event.keyCode==13){$('#right').click();};"></asp:ListBox>
                            </ContentTemplate>
                            <Triggers>
                                <Ajax:AsyncPostBackTrigger ControlID="rblTo" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </Ajax:UpdatePanel>
                    </td>
                    <td style="width:5%">
                        <br />
                        <br />
                        <img id="right" src="../../Images/Right.png" alt="" style="height: 29px" />
                        <br />

                        <br />
                        <img id="left" src="../../Images/Left.png" alt="" style="height: 29px" />
                    </td>
                    <td align="left">
                        <br />
                        <br />
                        Circular To :<br />
                        <asp:ListBox ID="lbselectedList" runat="server" Rows="5" ViewStateMode="Enabled" Width="355px" Height="90px" ClientIDMode="Static" onkeyup="if(event.keyCode==13){$('#left').click();};"></asp:ListBox>
                        <asp:HiddenField ID="lblUserOrDeptList" runat="server" ClientIDMode="Static" />
                        <%--  <asp:TextBox ID="txtTest" runat="server"></asp:TextBox>--%>
                    </td>
                </tr>

                <tr>
                    <td style="width: 100px; height: 25px;"></td>
                    <td style="width: 40px; text-align: left; height: 25px;">Subject :&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td colspan="3" style="text-align: left; height: 25px;">
                        <asp:TextBox ID="txtsub" runat="server" ClientIDMode="Static" Width="98%" CssClass="required" MaxLength="50" AutoCompleteType="Disabled" data-title="Enter Circular Subject"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtsub"
                            ErrorMessage="*"></asp:RequiredFieldValidator>
                    </td>
                    <td style="width: 100px; height: 25px;"></td>
                </tr>
                <tr style="display: none;">
                    <td style="width: 100px"></td>
                    <td style="width: 18px" align="left">
                        <strong><span style="font-family: Verdana">Document&nbsp;No.:</span></strong>
                    </td>
                    <td colspan="3" style="text-align: left;">
                        <asp:TextBox ID="txtDocNo" runat="server" Width="634px"></asp:TextBox></td>
                    <td style="width: 100px"></td>
                </tr>
                <tr>
                    <td style="width: 100px"></td>
                    <td colspan="4" rowspan="2">
                        <strong><span style="font-family: Verdana"></span></strong>

                        <CKEditor:CKEditorControl ID="txtmsg" BasePath="~/ckeditor" runat="server" EnterMode="BR"></CKEditor:CKEditorControl>
                        &nbsp;
                    </td>
                    <td style="width: 100px"></td>
                </tr>
                <tr>
                    <td style="width: 100px"></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="width: 100px"></td>
                    <td style="width: 18px; text-align: right;" colspan="3">Attachment : <asp:FileUpload ID="fuAttechment" runat="server" /></td>
                    <td colspan="3" style="text-align: left;">
                        </td>

                    <td style="width: 100px"></td>
                </tr>
                <tr>
                    <td style="width: 100px"></td>
                    <td style="width: 18px"></td>
                    <td colspan="2" align="right">
                        <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton"
                            OnClientClick="return validate();" />
                    </td>
                    <td style="width: 91px"></td>
                    <td style="width: 100px"></td>
                </tr>
                <tr>
                    <td style="width: 100px"></td>
                    <td style="width: 18px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 91px"></td>
                    <td style="width: 100px"></td>
                </tr>
            </table>
        </div>

    </div>
    <script type="text/javascript">
        $(function () {
            $("#right").bind("click", function () {
                $('#<%=lbselectedList.ClientID%> option').prop("selected", false);
                var cond = 0;
                if ($('#<%=lbToList.ClientID%> option:selected').text() == "") {
                    $('#<%=lblmsg.ClientID%>').text('Please Select Available');
                    return false;
                    cond = 1;
                }
                if (cond == 0) {
                    var options = $('#<%=lbToList.ClientID%> option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#<%=lbselectedList.ClientID%>').append(opt);
                        $('#<%=lblUserOrDeptList.ClientID%>').val($('#<%=lblUserOrDeptList.ClientID%>').val() + ',' + (options[i].value));
                        var test = $('#<%=lblUserOrDeptList.ClientID%>').val();
                    }

                  
                }
                else {
                    $('#<%=lblmsg.ClientID%>').text('Please Select Available');
                    return false;
                }
            });
              $("#left").bind("click", function () {
                  var cond = 0;
                  if ($('#<%=lbselectedList.ClientID%> option:selected').text() == "") {
                    $('#<%=lblmsg.ClientID%>').text('Please Select Remaining');
                    return false;
                    cond = 1;
                }
                if (cond == 0) {
                    $('#<%=lblmsg.ClientID%>').text('');
                    var options = $('#<%=lbselectedList.ClientID%> option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#<%=lbToList.ClientID%>').append(opt);
                    }

                  

                }
                else {
                    $('#<%=lblmsg.ClientID%>').text('Please Select Remaining');
                    return false;
                }
            });

          });
    </script>
</asp:Content>
