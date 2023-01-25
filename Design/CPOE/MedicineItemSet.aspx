<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MedicineItemSet.aspx.cs" Inherits="Design_CPOE_MedicineItemSet" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral,
 PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lstitems.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });

            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstitems.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
                FindDose();
            });
            $('#<%=txtcpt.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstitems.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
                FindDose();
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstitems.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
                FindDose();
            });
        });
        $(document).ready(
               function () {
                   loadSets();
                   $("#<%=ddlSetItem.ClientID %>").change(EditItem);
                   $("#btnSave").attr('style', 'display:none;');
                   $("#btnAdd").click(AddItem);
                   $("#btnSave").click(SaveData);
                   var options = $('#<% = lstitems.ClientID %> option');

               });
               function wopen(url, name, w, h) {
                   w += 32;
                   h += 96;
                   var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
                   win.resizeTo(w, h);
                   win.moveTo(10, 100);
                   win.focus();
               }
               function loadSets() {
                   $("#<%=ddlSetItem.ClientID %>").empty();
                   var ddlSetItem = $("#<%=ddlSetItem.ClientID%>");
                   jQuery.ajax({
                       url: "MedicineItemSet.aspx/loadSets",
                       data: '{}',
                       type: "Post",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       async: false,
                       dataType: "json",
                       success: function (result) {
                           Data = jQuery.parseJSON(result.d);
                           if (Data.length != 0) {
                               ddlSetItem.append($("<option></option>").val("0").html("---Select---"));
                               for (i = 0; i < Data.length; i++) {
                                   ddlSetItem.append($("<option></option>").val(Data[i].ID).html(Data[i].Setname));
                               }
                           }
                           else
                               ddlSetItem.append($("<option></option>").val("0").html("PLease Create a Set"));
                       },
                       error: function (xhr, status) {
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }

        function GetDetail(){
            var chektext = document.getElementById('<%=btnCreateSet.ClientID%>').value;
            if (chektext == 'Update Set Name')
            {
                $("#txtSetName").val($("#<%=ddlSetItem.ClientID %>  option:selected").text());                 
                $("#btnSaveSet").val('Update');                
            }
            else
                $("#btnSaveSet").val('Save');
            }
   
        function checkInsertorUpdateSet() {
            var checkBtnText = $("#btnSaveSet").val();
            if (checkBtnText == 'Save')
                SaveSet();
            else
                UpdateSet();            
        }

        function UpdateSet() {
            if ($.trim($("#txtSetName").val()) != "") {
                var SetName = $("#txtSetName").val();
                var txtDescription = $.trim($("#<%=txtDescription.ClientID %>").val());
                var SetId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();                
                       $.ajax({
                           url: "MedicineItemSet.aspx/UpdateSet",
                           data: '{SetName:"' + SetName + '",Description:"' + txtDescription + '",ID:"' + SetId + '"}', // parameter map
                           type: "POST",
                           contentType: "application/json; charset=utf-8",
                           timeout: 120000,
                           async: false,
                           dataType: "json",
                           success: function (result) {
                               Data = (result.d);
                               if (Data == "2") {
                                   DisplayMsg('MM024', 'spnMsg');
                                   loadSets();
                                   $("#txtSetName").val(' ');
                                   $find('mpe').hide();
                                   jQuery("#ddlSetItem option").remove();
                               }
                               else if (Data == "1") {
                                   DisplayMsg('MM02', 'spnMsg');
                                   loadSets();
                                   $("#txtSetName").val(' ');
                                   $find('mpe').hide();
                                   $('#PatientMedicineSearchOutput').hide();
                               }
                               else if (Data == "0") {
                                   DisplayMsg('MM05', 'spnMsg');
                                   $("#txtSetName").val('');
                                   $find('mpe').hide();
                                   loadSets();
                               }
                           },
                           error: function (xhr, status) {
                               window.status = status + "\r\n" + xhr.responseText;
                               return false;
                           }
                       });
                   }
                   else {
                       $("#spnMsg").text("Please Enter Header Name");
                       $("#txtSetName").focus();
                   }
               }


        function SaveSet() {
            if ($.trim($("#txtSetName").val()) != "") {
                       var SetName = $("#txtSetName").val();                       
                       var txtDescription = $.trim($("#<%=txtDescription.ClientID %>").val());
                       $.ajax({
                           url: "MedicineItemSet.aspx/SaveSet",
                           data: '{SetName:"' + SetName + '",Description:"' + txtDescription + '"}', // parameter map
                           type: "POST",
                           contentType: "application/json; charset=utf-8",
                           timeout: 120000,
                           async: false,
                           dataType: "json",
                           success: function (result) {
                               Data = (result.d);
                               if (Data == "2") {
                                   DisplayMsg('MM024', 'spnMsg');
                                   loadSets();
                                   $("#txtSetName").val(' ');
                                   $find('mpe').hide();
                                   jQuery("#ddlSetItem option").remove();
                               }
                               else if (Data == "1") {
                                   DisplayMsg('MM01', 'spnMsg');
                                   loadSets();
                                   $("#txtSetName").val(' ');
                                   $find('mpe').hide();
                               }
                               else if (Data == "0") {
                                   DisplayMsg('MM05', 'spnMsg');
                                   $("#txtSetName").val('');
                                   $find('mpe').hide();
                                   loadSets();
                               }

                           },
                           error: function (xhr, status) {
                               window.status = status + "\r\n" + xhr.responseText;
                               return false;
                           }
                       });
                   }
                   else {
                       $("#spnMsg").text("Please Enter Header Name");
                       $("#txtSetName").focus();
                   }
               }  

               function EditItem() {
                   $("#<%=lblmsg.ClientID %>").text('');
                   setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
                   if (setId != "0") {
                       document.getElementById('<%=btnCreateSet.ClientID%>').value = 'Update Set Name';                       
                  }
                   else {
                      document.getElementById('<%=btnCreateSet.ClientID%>').value = 'Create Set';                     
                  }
                   var ItemData = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
                   if ($("#<%=ddlSetItem.ClientID %>  option:selected").text().toUpperCase() == "SELECT") {
                       $("#<%=lblmsg.ClientID %>").text('Please Select Set Name');
                       $(".show").hide();
                       $('#btnAdd').attr('style', 'display:none');
                       $('#btnSave').attr('style', 'display:none');
                       $('#PatientMedicineSearchOutput').hide();
                       return;
                   }
                   $.blockUI();
                   $.ajax({
                       url: "MedicineItemSet.aspx/LoadSetItems",
                       data: '{SetID:' + setId + '}',
                       type: "POST",
                       contentType: "application/json;charset=utf-8",
                       timeout: 120000,
                       dataType: "json",
                       success: function (result) {
                           PatientData = jQuery.parseJSON(result.d);
                           if (PatientData != null) {
                               var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                               $('#PatientMedicineSearchOutput').html(output);
                               $('#PatientMedicineSearchOutput').show();
                               $('#btnAdd').attr('style', 'display:""');
                               $('#btnSave').attr('style', 'display:none');
                               $(".show").show();
                               $.unblockUI();
                           }
                           else {
                               $('#PatientMedicineSearchOutput').hide();
                               $('#PatientMedicineSearchOutput').clearQueue();
                               DisplayMsg('MM253', 'spnMsg');
                               $.unblockUI();
                           }


                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnMsg');
                    $("#btnSave").attr('disabled', false);
                    $.unblockUI();
                }
            });

        }



        function SaveData() {
            if ($.trim($("#<%=ddlSetItem.ClientID %> ").val()) != "0") {
                var dataLTDt = new Array();
                var ObjLdgTnxDt = new Object();
                jQuery("#tb_grdLabSearch tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Header") {
                        ObjLdgTnxDt.SetID = jQuery.trim($rowid.find("#td_setId").text());
                        ObjLdgTnxDt.ItemID = jQuery.trim($rowid.find("#td_ItemID").text().split('#')[0]);
                        ObjLdgTnxDt.Quantity = jQuery.trim($rowid.find("#td_Qty").text());
                        ObjLdgTnxDt.Dose = jQuery.trim($rowid.find("#td_Dose").text());
                        ObjLdgTnxDt.Route = jQuery.trim($rowid.find("#td_Route").text());
                        ObjLdgTnxDt.Meal = jQuery.trim($rowid.find("#td_Meal").text());
                        ObjLdgTnxDt.Time = jQuery.trim($rowid.find("#td_Time").text());
                        ObjLdgTnxDt.Duration = jQuery.trim($rowid.find("#td_Duration").text());
                        dataLTDt.push(ObjLdgTnxDt);
                        ObjLdgTnxDt = new Object();
                    }

                });
                if (dataLTDt.length > 0) {
                    $.ajax({
                        url: "MedicineItemSet.aspx/SaveSetItem",
                        data: JSON.stringify({ Data: dataLTDt }),
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            Data = result.d;

                            if (Data == "1") {
                                $("#tb_grdLabSearch tr:not(:first)").remove();
                                $("#tb_grdLabSearch").hide();
                                DisplayMsg('MM01', 'spnMsg');
                                $("#btnSave").hide();
                                EditItem();

                            }
                            else {
                                $("spnMsg").text('Record Not Saved');
                            }
                            $("#btnSave").attr('disabled', false);
                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'spnMsg');
                            $("#btnSave").attr('disabled', false);
                        }
                    });
                }
            }
        }
        var RowCount;
        var setId;
        function AddItem() {
            if ($("#<%=ddlSetItem.ClientID %> option:selected").val() != '0') {
                var ItemName = $("#<%=lstitems.ClientID %> option:selected").text();
                var ItemID = $("#<%=lstitems.ClientID %> option:selected").val().split('#')[0];
                var Qty = $("#<%=txtQty.ClientID%>").val();
                var Dose = $("#<%=txtDose.ClientID%>").val();
                var Route = "";
                if ($("#<%=ddlRoute.ClientID %>").val() != "Select")
                    var Route = $("#<%=ddlRoute.ClientID %>").val();

                var Meal = $("#<%=ddlMeal.ClientID %>").val();
                var Time = $("#<%=ddlTime.ClientID %> option:selected").val() + '#' + $("#<%=ddlTime.ClientID %> option:selected").text();
                var Duration = $("#<%=ddlDuration.ClientID %>  option:selected").val() + '#' + $("#<%=ddlDuration.ClientID %>  option:selected").text();
                // var Qty = 1;
                if (Qty == "" || Qty == "0") {
                    alert('Please Enter Quantity');
                    $("#<%=txtQty.ClientID %>").focus();
                    if ($("#tb_grdLabSearch tr").length == "1") {
                        $("#btnSave").hide();
                    }
                    else {
                        $("#btnSave").show();
                    }
                    return;
                }
                if ($("#<%=lstitems.ClientID %> option:selected").length == "0") {
                    DisplayMsg('MM018', 'spnMsg');
                    $("#btnSave").attr('style', 'display:none');
                    return;
                }
                RowCount = $("#tb_grdLabSearch tr").length;
                RowCount = RowCount + 1;

                var AlreadySelect = 0;
                if (RowCount > 2) {

                    $("#tb_grdLabSearch tr").each(function () {
                        if ($(this).attr("id") == 'tr_' + ItemID) {
                            AlreadySelect = 1;
                            return;
                        }
                    });
                    if ($("#<%=ddlSetItem.ClientID %>  option:selected").val() != setId) {
                        alert('Set Name Cannot Change');
                        $("#<%=ddlSetItem.ClientID %>").focus();
                        return;
                    }
                }
                setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
                var setName = $("#<%=ddlSetItem.ClientID %>  option:selected").text();
                if (setName.toUpperCase() == "SELECT") {
                    DisplayMsg('MM242', 'spnMsg');
                    $("#<%=ddlSetItem.ClientID %>").focus();
                    $("#btnSave").hide();
                    return;
                }
                if (AlreadySelect == "0") {
                    var newRow = $('<tr />').attr('id', 'tr_' + ItemID);
                    newRow.html('<td class="GridViewLabItemStyle" >' + (RowCount - 1) +
                         '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_setId >' + setId +
                         '</td><td class="GridViewLabItemStyle" style="text-align:left" id=td_setName >' + setName +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:left" id=td_ItemName >' + ItemName +
                         '</td><td  class="GridViewLabItemStyle" style="display:none;" id=td_ItemID >' + ItemID +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Dose >' + Dose +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Time >' + Time +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Duration >' + Duration +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Meal >' + Meal +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Route >' + Route +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Qty >' + Qty +
                         '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove" /></td>'
                        );
                    $("#tb_grdLabSearch").append(newRow);
                    $("#tb_grdLabSearch").show();
                    $("#<%=txtQty.ClientID %>").val('');
                    $("#<%=txtDose.ClientID%>").val('');
                    $("#<%=ddlRoute.ClientID%>").val('');
                    $("#<%=ddlDuration.ClientID%>").val('');
                    $("#<%=ddlMeal.ClientID%>").val('');
                    $("#<%=ddlTime.ClientID%>").val('');
                    $("#btnSave").attr('style', 'display:""');
                }
                else {
                    DisplayMsg('MM035', 'spnMsg');
                    alert('Item Already Selected');
                }
                $('#<% = txtInBetweenSearch.ClientID %>').val('');
                $('#<% = txtInBetweenSearch.ClientID %>').focus();
            }
            else {
                alert('Please Select the Proper Set');
                $('#<% =ddlSetItem.ClientID %>').focus();
            }
        }
        function DeleteRow(rowid) {
            var row = rowid;
            $(row).closest('tr').remove();
            RowCount = RowCount - 1;
            if ($("#tb_grdLabSearch tr").length == "1") {
                $("#btnSave").hide();
                $("#tb_grdLabSearch").hide();
            }
            else {
                $("#btnSave").show();
            }
        }
        function CheckQtyRecive(RecievedQty) {
            var TDSAmt = $(RecievedQty).val();
            if (TDSAmt.match(/[^0-9]/g)) {
                TDSAmt = TDSAmt.replace(/[^0-9]/g, '');
                $(RecievedQty).val(TDSAmt)
                return;
            }
        }
        document.onkeyup = Esc;
        function Esc() {
            var KeyID = event.keyCode;
            if (KeyID == 27) {
                if ($find("mpe")) {
                    $find("mpe").hide();
                }
            }
        }
        function clearpopup() {
            $("#<%=lblSetError.ClientID %>").text('');
            $("#txtSetName").val('');
            $("#<%=txtDescription.ClientID %>").val('');
        }
        function pageLoad() {
            var modalPopup = $find("mpe");
            if (modalPopup != null) {
                modalPopup.add_shown(OnPopupShow);
            }
        }
        function OnPopupShow() {
            var tb = $get("txtSetName");
            tb.focus();
        }
        function closeSet() {
            $find("mpe").hide();
            clearpopup();
        }
        function bindSet() {
            $("#<%=ddlSetItem.ClientID %> option").remove();
            $.ajax({
                url: "Services/SetMaster.asmx/BindSet",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    SetData = jQuery.parseJSON(result.d);
                    if (SetData.length == 0) {
                        $("#<%=ddlSetItem.ClientID %>").append($("<option></option>").val("0").html("Select"));
                    }
                    else {
                        for (i = 0; i < SetData.length; i++) {
                            $("#<%=ddlSetItem.ClientID %>").append($("<option></option>").val(SetData[i].SetID).html(SetData[i].NAME));
                        }
                    }

                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnMsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';

        }
        $(function () {
            var MaxLength = 100;
            $("#<% =txtDescription.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<% =txtDescription.ClientID %>").bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
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
        function validatespace() {
            var Name = $("#txtSetName").val();
            if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',' || Name.charAt(0) == '0' || Name.charAt(0) == "'" || Name.charAt(0) == '-') {
                $("#txtSetName").val('');
                $('#<%=lblSetError.ClientID %>').text('First Character Cannot Be Space/Dot');
                Name.replace(Name.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblSetError.ClientID %>').text('');
                return true;
            }
        }
        function check(e) {
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

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }
        function check1(e) {
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
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/") {
                return false;
            }
            else {
                return true;
            }
        }
    </script>

    <script type="text/javascript" >
        function splcharval(id) {
            id.value = id.value.replace(/[#|\']/g, '');
        }
        //For Search By Word
        function MoveUpAndDownText(textbox2, listbox2) {
            $('#<%=txtDose.ClientID %>').val($('#<%=lstitems.ClientID%>').val().split('#')[1]);
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }
            }
        }
        function MoveUpAndDownTextCatID(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            ItemID = listbox.options[m + 1].value.toString().split('#', 2);
                            textbox.value = ItemID[1];
                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            ItemID = listbox.options[m - 1].value.toString().split('#', 2);
                            textbox.value = ItemID[1];
                            return;
                        }
                    }
                }
            }
        }
        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString().trim();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
        }

        function suggestNameOnCatalogID(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString().split('#', 2);
                    if (suggestion[1] != '') {
                        if (suggestion[1].length >= level)
                            suggestionID = suggestion[1].substring(0, level).toLowerCase();
                    }
                    else
                        suggestionID = '';
                    if (soFarLeft == suggestionID) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }

                }
                if (matched && level < soFar.length) { level++; suggestNameOnCatalogID(textbox, listbox, level) }
            }
        }
        function AddInvestigation(sender, evt) {
            if (evt.keyCode > 0) {
                keyCode = evt.keyCode;
            }
            else if (typeof (evt.charCode) != "undefined") {
                keyCode = evt.charCode;
            }
            if (keyCode == 13) {
                document.getElementById('btnAdd').click();
            }
        }
    </script>
    <div id="Pbody_box_inventory">
            <cc1:ToolkitScriptManager ID="scripmanger" runat="server">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Medicine Set Master <br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
            </asp:Label>
             <span id="spnMsg" class="ItDoseLblError"></span><br />
        </div>
        <div class="POuter_Box_Inventory">
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlSetItem" runat="server"  ToolTip="Select Sets"  ></asp:DropDownList>
                        </div>
                        <div  class="col-md-3">
                             <asp:Button ID="btnCreateSet" Text="Create Set" CssClass="ItDoseButton" ClientIDMode="Static" ToolTip="Click To Create New Set" runat="server"  OnClientClick="GetDetail()"/>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearch" runat="server"  ClientIDMode="Static" onkeydown="AddInvestigation(this, event);" >
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                          <div class="col-md-4">
                            <label class="pull-left">
                                Search By Any Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInBetweenSearch" runat="server" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"
                                 onkeydown="AddInvestigation(this, event);" />
                        </div>
                          <div class="col-md-2"></div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                CPT Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtcpt" runat="server"  onkeydown="AddInvestigation(this, event);"  />
                        </div>
                    </div>
                    <div class="row">
                          <div class="col-md-3">
                            <label class="pull-left">
                                Item List
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:ListBox ID="lstitems" runat="server" Height="208px" Width="408px" ToolTip="Select Items" ClientIDMode="Static" onchange="onchangelist()"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Dose
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtDose" ToolTip="Enter Dose." CssClass="ItDoseTextinputText" runat="server"  onKeyUp="QuantityCal();"></asp:TextBox>     
                            <cc1:FilteredTextBoxExtender  ID="filterDose" runat="server" FilterType="Numbers,Custom" ValidChars="." TargetControlID="txtDose"></cc1:FilteredTextBoxExtender>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Times
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTime" runat="server"  ToolTip="Select Time" ClientIDMode="Static" onchange="QuantityCal();"> 
                                    </asp:DropDownList>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Duration
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlDuration" runat="server" ToolTip="Select Duration" ClientIDMode="Static" onchange="QuantityCal();">
                             </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Meal
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlMeal" runat="server"  ToolTip="Select Meal">
                                <asp:ListItem Value=""></asp:ListItem>
                                <asp:ListItem Value="After Meal">After Meal</asp:ListItem>
                                <asp:ListItem Value="Before Meal">Before Meal</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Route
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlRoute" runat="server" ToolTip="Select Route"  ClientIDMode="Static">
                                    </asp:DropDownList>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtQty" ToolTip="Enter Qty." CssClass="ItDoseTextinputNum" runat="server" MaxLength="3" ClientIDMode="Static"
                            onkeyup="CheckQtyRecive(this);"></asp:TextBox>                        
                            <cc1:FilteredTextBoxExtender  ID="ftbQty" runat="server" FilterType="Numbers,Custom" ValidChars="." TargetControlID="txtQty"></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-11"></div>
                        <div class="col-md-2">
                             <input id="btnAdd" value="Add" type="button" class="ItDoseButton" title="Click To Add Item" />
                        </div>
                        <div class="col-md-11"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table  style="width: 100%; border-collapse:collapse">
                <tr style="text-align: center">
                    <td colspan="4">
                        <table class="GridViewStyle"    rules="all" border="1" id="tb_grdLabSearch"
                            style="width:100%;  border-collapse: collapse; display: none;">
                            <tr id="Header">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Set Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 320px;">Item Name
                                </th>
                                
                                <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Dose
                                </th>
                                 <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Time
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Duration
                                </th>
                                  <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Route
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Meal
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Quantity
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Remove
                                </th>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table  style="width: 100%; border-collapse:collapse">
                <tr>
                    <td colspan="4" style="text-align: center;">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center;">
                        <input id="btnSave" value="Save" type="button" class="ItDoseButton" title="Click To Save" />
                    </td>
                </tr>
            </table>
            <table  style="width: 100%; border-collapse:collapse">
                <tr style="text-align:center">
                    <td colspan="4">
                        <div id="PatientMedicineSearchOutput" style="height:200px;display:none;" >
                        </div>
                       
                    </td>
                   
                </tr>
                <tr style="text-align:center"><td> 
                    <input id="btnitem" value="Update"  style="display:none" type="button" class="ItDoseButton"/>
                                              </td></tr>
            </table>
        </div>
    </div>
    <asp:Panel ID="pnlSetMaster" runat="server" Style="width: 380px; display: none" CssClass="pnlOrderItemsFilter">
        <div id="Div1" runat="server" class="Purchaseheader">
            <b>Create Set </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
             &nbsp;&nbsp; &nbsp;  <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeSet()"/>                               
                                to close</span></em>
        </div>
        <table  style="width: 100%;border-collapse:collapse">
            <tr style="text-align: center;">
                <td colspan="2">
                    <asp:Label ID="lblSetError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr style="text-align: center;">
                <td  style="width: 40px;text-align:right">Set&nbsp;Name :&nbsp;
                </td>
                <td  style="width: 240px;text-align:left">
                    <input id="txtSetName" size="34" maxlength="50" value="" title="Enter Set Name" onkeypress="return check(event)"
                        onkeyup="validatespace();" />
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
            </tr>
            <tr style="text-align: center;">
                <td  style="width: 40px;text-align:right;vertical-align:top">Description :&nbsp;
                </td>
                <td  style="width: 240px;text-align:left">
                    <asp:TextBox ID="txtDescription" onkeypress="return check1(event)" runat="server"
                        value="" Height="50px" Width="234px" TextMode="MultiLine" ToolTip="Enter Set Description"></asp:TextBox>
                </td>
            </tr>
            <tr style="text-align: center;">
                <td colspan="2">
                    <input type="button" id="btnSaveSet" value="Save" class="ItDoseButton" onclick="checkInsertorUpdateSet()" />
                    <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe" runat="server" PopupControlID="pnlSetMaster" DropShadow="true"
        BackgroundCssClass="filterPupupBackground" BehaviorID="mpe" TargetControlID="btnCreateSet"
        CancelControlID="btnCancel" OnCancelScript="clearpopup()">
    </cc1:ModalPopupExtender>

     <script id="tb_PatientMedicineSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1"
    style="width:100%;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Set Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:65px; display:none">Item ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:380px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Dose</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Route</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Meal</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Duration</th>
            <th class="GridViewHeaderStyle" scope="col"  style="width:45px;">Remove</th>
		</tr>

        <#
       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
        
          #>
                    <tr id="<#=objRow.SetID#>|<#=objRow.ItemID#>" >
                        <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td id="Td1" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
                        <td id="SetID" class="GridViewLabItemStyle" style="display:none"><#=objRow.SetID#></td>
                        <td id="SetName" class="GridViewLabItemStyle"><#=objRow.setName#></td>
                        <td id="ItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
                        <td  id="ItemName" class="GridViewLabItemStyle"><#=objRow.NAME#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.quantity#></td>
                        <td id="tdDose" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.dose#></td>
                        <td id="tdRoute" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.route#></td>
                        <td id="tdMeal" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.meal#></td>
                        <td id="tdTime" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.times#></td>
                        <td id="tdDuration" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.duration#></td>
                    <td class="GridViewLabItemStyle" id="tdDelete" style="text-align:center;">
                    <img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteData(this)" onmouseover="chngcur()" title="Click To Remove"/>
                    </td>

                </tr>   

            <#}#>

     </table>    
    </script>
     <script type="text/javascript">
         function DeleteData(rowid) {
             if ($.trim($("#<%=ddlSetItem.ClientID %> ").val()) != "0") {
                 var ID = $(rowid).closest('tr').find("#Td1").text();
                 $.ajax({
                     url: "MedicineItemSet.aspx/UpdateItem",
                     data: '{ID:"' + ID + '" }', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {
                         Data = result.d;
                         if (Data == "1") {
                             DisplayMsg('MM02', 'spnMsg');
                             EditItem();
                         }
                         else {
                             DisplayMsg('MM124', 'spnMsg');
                         }
                         $("#btnSave").attr('disabled', false);
                     },
                     error: function (xhr, status) {
                         DisplayMsg('MM05', 'spnMsg');
                         $("#btnSave").attr('disabled', false);
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }
         }

         </script>
    <script type="text/javascript">
        function FindDose() {
            $('#<%=txtDose.ClientID %>').val($('#<%=lstitems.ClientID%>').val().split('#')[1]);
            var dropdownlistbox = document.getElementById("ddlRoute")
            var givenValue = $('#<%=lstitems.ClientID%>').val().split('#')[3];
            FindSelectedIndex(dropdownlistbox, givenValue);
        }  
        function FindSelectedIndex(dropdownlistbox, givenValue) {
            for (var x = 0; x < dropdownlistbox.length - 1 ; x++) {
                if (givenValue == dropdownlistbox.options[x].text)
                    dropdownlistbox.selectedIndex = x;
            }
        }

      //  function QuantityCal() {
      //      var Time = $('#<%=ddlTime.ClientID%>').val();
      //      var Duration = $('#<%=ddlDuration.ClientID%>').val();

      //      var MedicineType = $("#<%=lstitems.ClientID %>").val().split('#')[2];                   

      //      var Quantity = 0;
      //       if (MedicineType == "tablet" || MedicineType == "capsule"){
      //          Quantity = Time * Duration;
      //          if (Quantity != 0)
      //              $('#<%=txtQty.ClientID%>').val(Quantity);
      //          else
      //              $('#<%=txtQty.ClientID%>').val('1');
      //      }
      //      else if (MedicineType == "Syrup" || MedicineType == "EyeDrop" || MedicineType == "EarDrop" || MedicineType == "NosalDrop" || MedicineType == "Tube"
      //          || MedicineType == "Lotion" || MedicineType == "Cream" || MedicineType == "Injection" || MedicineType == "Inhaler"
      //          ) {
      //             $('#<%=txtQty.ClientID%>').val('1');
      //          }  
      //          else {
      //              $('#<%=txtQty.ClientID%>').val('');
      //          }
        //  }  

        function QuantityCal() {
            var Time = $('#<%=ddlTime.ClientID%>').val();
            var Duration = $('#<%=ddlDuration.ClientID%>').val();
            var Dose = $("#<%=txtDose.ClientID%>").val();
            var Categoryid = $("#<%=lstitems.ClientID %>").val().split('#')[4];
            var Quantity = 0;
            if (Categoryid == "LSHHI5") {
                Quantity = Dose * Time * Duration;
                if (Quantity != 0)
                    $('#<%=txtQty.ClientID%>').val(Quantity);
                else
                    $('#<%=txtQty.ClientID%>').val('1');
            }
            else {
                $('#<%=txtQty.ClientID%>').val(''); 
            }
        }

        function onchangelist()
        {
            var Categoryid = $("#<%=lstitems.ClientID %>").val().split('#')[4];  
            if (Categoryid == "LSHHI5") {
                enablecontrol();
            }
            else
                disablecontrol();
        }

        function enablecontrol() {
                $('#<%=txtQty.ClientID%>').attr('disabled', 'disabled');
                $('#<%=txtDose.ClientID%>').removeAttr('disabled');
                $('#<%=ddlTime.ClientID%>').removeAttr('disabled');
                $('#<%=ddlDuration.ClientID%>').removeAttr('disabled');
                $('#<%=ddlMeal.ClientID%>').removeAttr('disabled');
                $('#<%=ddlRoute.ClientID%>').removeAttr('disabled');
            }
        function disablecontrol() {
                $('#<%=txtQty.ClientID%>').removeAttr('disabled');
                $('#<%=txtQty.ClientID%>').val('');
                $('#<%=txtDose.ClientID%>').attr('disabled', 'disabled');
                $('#<%=txtDose.ClientID%>').val('');
                $('#<%=ddlTime.ClientID%>').attr('disabled', 'disabled');
                $('#<%=ddlTime.ClientID%>').val('');
                $('#<%=ddlDuration.ClientID%>').attr('disabled', 'disabled');
                $('#<%=ddlDuration.ClientID%>').val('');
                $('#<%=ddlMeal.ClientID%>').attr('disabled', 'disabled');
                $('#<%=ddlMeal.ClientID%>').val('');
                $('#<%=ddlRoute.ClientID%>').attr('disabled', 'disabled');      
                $('#<%=ddlRoute.ClientID%>').val('');
        }
    
    </script>
</asp:Content>

