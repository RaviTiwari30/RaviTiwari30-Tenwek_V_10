<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="FormulaMaster.aspx.cs" Inherits="Design_LAB_FormulaMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>
    <script type="text/javascript">

        var values = [];
        $(document).ready(function () {
            var options = $('#<% = ddlInvestigations.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);

            });

            $('#<%=delete.ClientID %>').hide();

            $('#<%=txtSearch.ClientID %>').bind("keyup keydown", function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                var filter = $(this).val();
                if (filter == '') {
                    $('#<% = ddlInvestigations.ClientID %> option:nth-child(1)').attr('selected', 'selected');
                    return;
                }
             DoListBoxFilter('#<% = ddlInvestigations.ClientID %>', '#<% = txtSearch.ClientID %>', '0', filter, values);

         });
            $('#ddlHead,#ddlInvestigations').chosen();

        });
     function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values) {
         var list = $(listBoxSelector);
         if (searchtype == "0") {
             for (i = 0; i < values.length; ++i) {
                 var value = '';
                 if (values[i].indexOf('#') == -1)
                     continue;
                 else
                     value = values[i].split('#')[0];
                 var len = $(textbox).val().length;
                 if (value.toLowerCase().match(filter.toLowerCase())) {
                     $('#<% = ddlInvestigations.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', i);
                     return;
                 }

             }
         }

     }
     function bindformula(labobservation_id) {

         $.ajax({
             url: "../Lab/Services/MapInvestigationObservation.asmx/Formula",
             data: '{ labobservation_id: "' + labobservation_id + '",formulaText:"' + $("#<%=txtFormulaRight.ClientID %>").val() + '",Name:"' + $("#<%=txtFormulaLeft.ClientID %>").val() + '"}', // parameter map
             type: "POST", // data has to be Posted    	        
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             async: false,
             dataType: "json",
             success: function (result) {
                 RateData = result.d

                 if (RateData != '') {
                     var newvalue = RateData.split('$')[2];

                     var value = newvalue.split('|')[0];

                     var data = RateData.split('$')[1];

                     if (data != '') {
                         $('#<%=lblobs.ClientID %>').text(value);
                         $('#<%=lblformula.ClientID %>').text(data);
                         $('#<%=lblequals.ClientID %>').text('=');
                         $('#<%=delete.ClientID %>').show();

                     }
                     else {
                         $('#<%=lblobs.ClientID %>').text('');
                         $('#<%=lblformula.ClientID %>').text('');
                         $('#<%=lblequals.ClientID %>').text('');
                         $('#<%=delete.ClientID %>').hide();
                     }
                 }
                 else {
                     $('#<%=lblobs.ClientID %>').text('');
                     $('#<%=lblformula.ClientID %>').text('');
                     $('#<%=lblequals.ClientID %>').text('');
                     $('#<%=delete.ClientID %>').hide();

                 }

             },
             error: function (xhr, status) {
                 modelAlert("Error"); 
                 window.status = status + "\r\n" + xhr.responseText;
             }
         });
     }
     function Deleteformula(labobservation_id) {

         $.ajax({
             type: "POST",
             url: "../Lab/Services/MapInvestigationObservation.asmx/DeleteFormula",
             data: '{ labobservation_id: "' + labobservation_id + '"}', // parameter map
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             async: false,
             dataType: "json",
             success: function (result) {
                 data = jQuery.parseJSON(result.d);
                 if (data == "1") {
                     modelAlert('Record Deleted Successfully');
                     //alert('Record Deleted Successfully');
                     $('#<%=lblobs.ClientID %>').text('');
                     $('#<%=lblformula.ClientID %>').text('');
                     $('#<%=lblequals.ClientID %>').text('');
                     $('#<%=delete.ClientID %>').hide();
                 }

             }

         });
     }


     function delete_onclick() {
         var obsdelete = $("#<%=lstObservations.ClientID %> option:selected ").val();

         Deleteformula(obsdelete);
     }

    </script>
    <script type="text/javascript">
        function Formula(Symbol) {
            try {
                document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxtHidden').value = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxtHidden').value + '' + Symbol;
                document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRightHidden').value = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRightHidden').value + '' + Symbol;
                document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRight').value = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRight').value + '' + Symbol;
                document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxt').value = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxt').value + '' + Symbol;
                var FormulaRightHidden = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRightHidden').value;
                var FormulaRight = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRight');
                var txtFormulatxt = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxt');
                var txtFormulatxtHidden = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxtHidden');

            }
            catch (e) { alert(e); }
        }
        function copyTextEvent(e) {

            var evtobj = window.event ? event : e //distinguish between IE's explicit event object (window.event) and Firefox's implicit.
            var unicode = evtobj.charCode ? evtobj.charCode : evtobj.keyCode
            var actualkey = String.fromCharCode(unicode)
            var unicode = e.keyCode ? e.which : e.charCode
            document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRightHidden').value = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRightHidden').value + '' + actualkey;
            var FormulaRightHiddennew = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulaRightHidden').value;
            document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxtHidden').value = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxtHidden').value + '' + actualkey;
            var FormulaRightHiddennew = document.getElementById('ctl00_ContentPlaceHolder1_txtFormulatxtHidden').value;
        }
        function fun() {
            var obs = $("#<%=lstObservations.ClientID %> option:selected ").val();
            $('#<%=lblMsg.ClientID %>').hide();
            bindformula(obs);

        }


        function btnAdd_onclick() {

        }
        $(document).ready(function () {
            $("#<%=txtFormulaRight.ClientID %>").keyup(function (e) {
                if (e.keyCode == 48 || e.keyCode == 96) {
                    Formula('0');
                }
                if (e.keyCode == 49 || e.keyCode == 97) {
                    Formula('1');
                }
                if (e.keyCode == 50 || e.keyCode == 98) {
                    Formula('2');
                }
                if (e.keyCode == 51 || e.keyCode == 99) {
                    Formula('3');
                }
                if (e.keyCode == 52 || e.keyCode == 100) {
                    Formula('4');
                }
                if (e.keyCode == 53 || e.keyCode == 101) {
                    Formula('5');
                }
                if (e.keyCode == 54 || e.keyCode == 102) {
                    Formula('6');
                }
                if (e.keyCode == 55 || e.keyCode == 103) {
                    Formula('7');
                }
                if (e.keyCode == 56 || e.keyCode == 104) {
                    Formula('8');
                }
                if (e.keyCode == 57 || e.keyCode == 105) {
                    Formula('9');
                }
                if (e.keyCode == 110 || e.keyCode == 190) {
                    Formula('.');
                }
                if (e.keyCode == 107) {
                    Formula('+');
                }
                if (e.keyCode == 109) {
                    Formula('-');
                }
                if (e.keyCode == 106) {
                    Formula('*');
                }
                if (e.keyCode == 111) {
                    Formula('/');
                }
                if (e.keyCode == 219) {
                    Formula('(');
                }
                if (e.keyCode == 221) {
                    Formula(')');
                }
                if (e.keyCode == 8) {
                    $("#<%=txtFormulaRight.ClientID %>").val('');
                    $("#<%=txtFormulaRightHidden.ClientID %>").val('');
                    $("#<%=txtFormulaRight.ClientID %>").val('');
                    $("#<%=txtFormulaRightHidden.ClientID %>").val('');
                    $("#<%=txtFormulatxt.ClientID %>").val('');
                    $("#<%=txtFormulaLeft.ClientID %>").val('');
                    $("#<%=txtFormulatxtHidden.ClientID %>").val('');

                }
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Formula Creation&nbsp;</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlHead" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlHead_SelectedIndexChanged"
                                Style="margin-left: 0px" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Investigations
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlInvestigations" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlInvestigations_SelectedIndexChanged" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                CPT Code:
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearch" runat="server" AutoCompleteType="disabled"
                                CssClass="ItDoseTextinputText" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="Purchaseheader">
                    Privilege Detail
                </div>
            </div>
            <div class="row">
                <div class="col-md-10">
                    <div class="row">
                        <strong>Observations</strong>
                    </div>
                    <div class="row" align="right">
                        <asp:ListBox ID="lstObservations" runat="server" Height="228px" SelectionMode="Multiple"
                            CssClass="ItDoseListbox" Width="350px" onchange="fun()"></asp:ListBox>
                    </div>
                    <div class="row" style="margin-left:180px;">
                        <div class="col-md-6">
                            <input id="btnAdd" type="button" value="Add" class="ItDoseButton" onclick="Formula('+')"
                                style="width: 70px" onclick="return btnAdd_onclick()" />
                        </div>
                        <div class="col-md-5">
                            <input id="btnSub" type="button" value="Subtract" class="ItDoseButton" style="width: 70px"
                                onclick="Formula('-')" style="width: 70px" />
                        </div>

                    </div>
                    <div class="row" style="margin-left:180px;">
                        <div class="col-md-6">
                            <input id="btnMultiply" type="button" value="Multiply" class="ItDoseButton" style="width: 70px"
                                onclick="Formula('*')" style="width: 70px" />
                        </div>
                        <div class="col-md-6">
                            <input id="btnDivide" type="button" value="Divide" class="ItDoseButton" style="width: 70px"
                                onclick="Formula('/')" />
                        </div>
                        <div class="col-md-5">
                            <input id="btnPower" type="button" value="Power" class="ItDoseButton"
                                onclick="Formula('Math.pow')" style="width: 70px" />
                        </div>
                    </div>
                    <div class="row" style="margin-left:180px;">
                        <div class="col-md-6">
                            <input id="btnOpenBk" type="button" value="(" class="ItDoseButton" style="width: 70px"
                                onclick="Formula('(')" />
                        </div>
                        <div class="col-md-6">
                            <input id="btnClosebk" type="button" value=")" class="ItDoseButton"
                                onclick="Formula(')')" style="width: 70px" />
                        </div>

                    </div>
                </div>
                <div class="col-md-5" style="margin-top: 94px;">
                    <div class="row">
                        <div class="col-md-4">
                            <asp:Button ID="btnLeft" Text="Left" runat="server" CssClass="ItDoseButton" OnClick="btnLeft_Click" Style="width: 50px;" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <div style="display: none;">
                                <asp:TextBox ID="txtFormulatxt" runat="server"></asp:TextBox>
                            </div>

                            <div>
                                <asp:TextBox runat="server" ID="txtFormulaLeft" Height="20px" Width="161px" Style="margin-left: 63px;" ReadOnly="true"></asp:TextBox>
                                <strong>=</strong></div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <asp:Button ID="BtnRight" Text="Right" runat="server" CssClass="ItDoseButton" OnClick="BtnRight_Click" Style="width: 50px;" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-10">
                           
                            <asp:Label ID="lblobs" runat="server" CssClass="ItDoseLblError"></asp:Label>
                             </div>
                              <div class="col-md-2">
                            <asp:Label ID="lblequals" runat="server" Font-Size="Medium" style="color:blue;" ></asp:Label> <%--CssClass="ItDoseLblError"--%>
                                   </div>
                                  
                    </div>
                    <div class="row">
                          <div >
                            <asp:Label ID="lblformula" runat="server" Font-Size="Medium" style="color:green;;" ></asp:Label>
                                         <img src="../../Images/Delete.gif" runat="server" id="delete"
                                onclick="return delete_onclick()" style="height: 13px" />
                        </div> 
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="row">
                        <asp:TextBox runat="server" ID="txtFormulaRight" TextMode="MultiLine" Height="181px"
                            Width="241px" Style="margin-top: 41px;"></asp:TextBox>
                    </div>
                    <div class="row">
                        <input id="btn1" type="button" value="1" class="ItDoseButton" style="width: 25px"
                            onclick="Formula('1')" />&nbsp;&nbsp;
                    <input id="btn2" type="button" value="2" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('2')" />&nbsp;&nbsp;
                    <input id="btn3" type="button" value="3" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('3')" />
                        &nbsp;
                    <input id="button1" type="button" value="+" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('+')" />&nbsp;&nbsp;
                              <input id="btnOpenBk0" class="ItDoseButton" onclick="Formula('(')" style="width: 50px" type="button" value="(" /><br />
                        <br />
                        <input id="btn4" type="button" value="4" class="ItDoseButton" style="width: 25px"
                            onclick="Formula('4')" />&nbsp;&nbsp;
                    <input id="btn5" type="button" value="5" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('5')" />&nbsp;&nbsp;
                    <input id="btn6" type="button" value="6" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('6')" />&nbsp;&nbsp;
                    <input id="button2" type="button" value="-" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('-')" />
                        &nbsp;&nbsp;<input id="btnOpenBk1" class="ItDoseButton" onclick="    Formula(')')" style="width: 50px" type="button" value=")" /><br />
                        <br />
                        <input id="btn7" type="button" value="7" class="ItDoseButton" style="width: 25px"
                            onclick="Formula('7')" onkeypress="AddValue();" />&nbsp;&nbsp;
                    <input id="btn8" type="button" value="8" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('8')" />&nbsp;&nbsp;
                    <input id="btn9" type="button" value="9" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('9')" />&nbsp;&nbsp;
                    <input id="buttonPoint" type="button" value="." class="ItDoseButton" style="width: 25px"
                        onclick="Formula('.')" />&nbsp;&nbsp;
                                <input id="btnPower0" type="button" value="Power" class="ItDoseButton"
                                    onclick="Formula('Math.pow')" style="width: 50px" /><br />
                        <br />
                        <input id="button3" type="button" value="*" class="ItDoseButton" style="width: 25px"
                            onclick="Formula('*')" />&nbsp;&nbsp;
                    <input id="btn0" type="button" value="0" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('0')" />&nbsp;&nbsp;
                    <input id="Button4" type="button" value="/" class="ItDoseButton" style="width: 25px"
                        onclick="Formula('/')" />&nbsp;&nbsp;
                    <asp:Button ID="btnClear" runat="server" Text="C" Style="width: 25px" CssClass="ItDoseButton" OnClick="btnClear_Click" />
                    </div>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 100%">
                <tr style="text-align: center;">
                    <td style="width: 62px;">
                        <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save"
                            CssClass="ItDoseButton"></asp:Button>
                    </td>
                    <td style="display: none;">
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="ItDoseButton"
                            OnClick="btnDelete_Click"></asp:Button>
                    </td>
                </tr>
            </table>
        </div>
    </div>


    <div style="display: none;">
        <table>
            <tr>
                <td style="height: 167px; width: 50px;">
                    <br />
                </td>
                <td style="height: 167px">
                    <asp:TextBox runat="server" ID="txtFormulaLeftHidden" Height="20px" Width="161px"></asp:TextBox>

                </td>
                <td style="height: 167px; width: 11px;"></td>
                <td style="width: 269px; height: 167px;">
                    <asp:TextBox runat="server" ID="txtFormulaRightHidden" TextMode="MultiLine" Height="181px"
                        Width="261px"></asp:TextBox>
                    <asp:TextBox runat="server" ID="txtFormulatxtHidden" TextMode="MultiLine" Height="181px"
                        Width="261px"></asp:TextBox>
                </td>
            </tr>
        </table>
    </div>

</asp:Content>
