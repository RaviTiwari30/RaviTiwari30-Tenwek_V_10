<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Demo_Tally_Interface_Master.aspx.cs" Inherits="Design_EDP_Demo_Tally_Interface_Master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript">    
        $(function () {

            $("#left").bind("click", function () {
                var cond = 0;
                if ($('#<%=lstRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Remaining');
                    return false;
                    cond = 1;
                }
                if ($('#<%=ddlCoseCentre.ClientID%> option:selected').val() == 0)
                {
                    $('#<%=lblMsg.ClientID%>').text('Please Select The Cost Centre');
                    $('#<%=ddlCoseCentre.ClientID%>').focus();
                    return false;
                    cond = 1;
                }
                if ($('#<%=ddlRevenueCentre.ClientID%> option:selected').val() == 0) {
                    $('#<%=lblMsg.ClientID%>').text('Please Select The Revenue Centre');
                    $('#<%=ddlRevenueCentre.ClientID%>').focus();
                    return false;
                    cond = 1;
                }
                if (cond == 0) {
                    $('#<%=lblMsg.ClientID%>').text('');
                    
                    var RevenueID = $('#<%=ddlRevenueCentre.ClientID%>').val();
                    if (RevenueID != "0") {
                        var options = $('#<%=lstRight.ClientID%> option:selected');
                        var data = new Array();
                        for (var i = 0; i < options.length; i++) {
                            var opt = $(options[i]).clone();
                            var obj = new Object();
                            obj.ItemID = $('#<%=lstRight.ClientID%> option:selected').val();
                            obj.CategoryID = $('#<%=ddlCategory.ClientID%> option:selected').val();
                            obj.SubCategoryID = $('#<%=ddlSubCategory.ClientID%> option:selected').val();
                            obj.RevenueID = $('#<%=ddlRevenueCentre.ClientID%> option:selected').val();
                            obj.RevenueName = $('#<%=ddlRevenueCentre.ClientID%> option:selected').text();
                            obj.CostCentreID = $('#<%=ddlCoseCentre.ClientID%> option:selected').val();
                            obj.CostCentreName = $('#<%=ddlCoseCentre.ClientID%> option:selected').text();
                            $(options[i]).remove();
                            $('#<%=lstAvailAbleRight.ClientID%>').append(opt);
                            data.push(obj);
                        }
                        if (data.length > 0) {
                            $.ajax({
                                url: "Demo_Tally_Interface_Master.aspx/InserMapping",
                                data: JSON.stringify({ Data: data }),
                                type: "POST", // data has to be Posted    	        
                                contentType: "application/json; charset=utf-8",
                                timeout: 120000,
                                dataType: "json",
                                async: false,
                                success: function (result) {
                                    if (result.d == "1") {
                                        $('#<%=lblMsg.ClientID%>').text('Record Saved Successfully');
                                    }
                                    if (result.d == "2") {
                                        $('#<%=lblMsg.ClientID%>').text('Item Already Mapped In Another Revenue Centre');
                                    }
                                    $('#<%=lstAvailAbleRight.ClientID%> option').attr("selected", false);
                                    ConButton();
                                    
                                },
                                error: function (xhr, status) {
                                    window.status = status + "\r\n" + xhr.responseText;
                                    $('#<%=lblMsg.ClientID%>').text('error');
                                    
                                }
                            });
                        }

                    }
                    else {
                        $('#<%=lblMsg.ClientID%>').text('Please Select Atleast One Item');
                        return false;
                    }
                }
                else {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Proper Revenue Centre');
                    return false;
                }
            });

            $("#right").bind("click", function () {
                $('#<%=lstRight.ClientID%> option').prop("selected", false);
                var cond = 0;
                if ($('#<%=lstAvailAbleRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Available');
                    return false;
                    cond = 1;
                }
                if (cond == 0) {
                    
                    var options = $('#<%=lstAvailAbleRight.ClientID%> option:selected');
                    var data = new Array();
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                       var obj = new Object();
                        obj.ItemID = $('#<%=lstAvailAbleRight.ClientID%> option:selected').val();
                        obj.RevenueID = $('#<%=ddlRevenueCentre.ClientID%> option:selected').val(); 
                        $(options[i]).remove();
                        data.push(obj);
                    }
                    if (data.length > 0) {
                        $.ajax({
                            url: "Demo_Tally_Interface_Master.aspx/MappingUpdate",
                            data: JSON.stringify({ Data: data }),
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: true,
                            dataType: "json",
                            success: function (result) {
                                if (result.d == "1") {
                                    $('#<%=lblMsg.ClientID%>').text('Mapping Removed Successfully');
                                }
                                ConButton();
                                
                                $('#<%=lstRight.ClientID%> option').attr("selected", false);
                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                                
                            }
                        });
                    }
                }
                else {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Available');
                    return false;
                }
            });
            
        });

        function BindNonMapItem() {
            
            var FrameRight = $("#<%=lstRight.ClientID %>");
            var ddlSubCategory = $("#<%=ddlSubCategory.ClientID %>").val();
            $("#<%=lstRight.ClientID %> option").remove();
            $.ajax({
                url: "Demo_Tally_Interface_Master.aspx/BindNonMapItem",
                data: '{SubCategory:"' + ddlSubCategory + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data != null) {
                        for (i = 0; i < Data.length; i++) {
                            FrameRight.append($("<option></option>").val(Data[i].ItemID).html(Data[i].TypeName));
                            $("#<%=lblMsg.ClientID%>").text(' ');
                        }
                    }
                    else {
                        $("#<%=lblMsg.ClientID%>").text('In This SubCategory No item Remaining For The Mapping');
                    }
                    ConButton();
                    
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    
                }
            });
        }
            function BindMaping(){
            var FrameLeft = $("#<%=lstAvailAbleRight.ClientID %>");
            $("#<%=lstAvailAbleRight.ClientID %> option").remove();
            $.ajax({
                url: "Demo_Tally_Interface_Master.aspx/BindMaping",
                data: '{RevenueName:"' + $("#<%=ddlRevenueCentre.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data != null) {
                        for (i = 0; i < Data.length; i++) {
                            FrameLeft.append($("<option></option>").val(Data[i].itemID).html(Data[i].TypeName));
                        }
                    }
                    ConButton();
                    
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    
                }
            });
        }
        

        $(document).ready(function () {
          ConButton();
     });

        function ConButton() {
            if ($('#<%=lstAvailAbleRight.ClientID%> option').length > 0) {
                $("#right").show();

            }
            else {
                $("#right").hide();

            }
            if ($('#<%=lstRight.ClientID%> option').length > 0) {
                $("#left").show();
            }
            else {
                $("#left").hide();
            }
        }
        $(document).ready(function () {

        });



    </script>


    <%--///////////////////////////////////////--%>
     <script type="text/javascript">
         function SaveRevenueCentre() {
             if ($.trim($("#txtRevenueCentre").val()) != "" && $.trim($("#txtDescription").val()) != "" && $('#<%=ddlCoseCentre1.ClientID%> option:selected').val() != "0") {
                 var RevenueCentre = $("#txtRevenueCentre").val();
                 var Description = $("#txtDescription").val();
                 var CostCentre =  $("#<%=ddlCoseCentre1.ClientID%> option:selected").val();
                 $.ajax({
                     url: "Demo_Tally_Interface_Master.aspx/RevenueInsert",
                     data: '{RevenueCentre: "' + RevenueCentre + '",Description:"' + Description + '",CostCentreID:"' + CostCentre + '"}', // parameter map
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         Data = (result.d);
                         if (Data == "2") {
                             $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
                             $("#txtRevenueCentre").val(' ');
                             $find('mpHeader').hide();
                             bindRevenueName();
                         }
                         else if (Data == "1") {
                             $("#<%=lblMsg.ClientID%>").text('Revenue Name Already Exist');
                             $("#txtRevenueCentre").val(' ');
                             $find('mpHeader').hide();
                             bindRevenueName();
                         }
                         else if (Data == "3") {
                             $("#<%=lblMsg.ClientID%>").text('Enter Revenue Name');
                             $("#txtRevenueCentre").val('');
                             $find('mpHeader').hide();
                             bindRevenueName();
                         }

                         else {
                             $("#<%=lblMsg.ClientID%>").text('Revenue Not Saved');
                             $find('mpHeader').hide();
                             bindRevenueName();
                         }

                     },
                     error: function (xhr, status) {
                         alert("Error ");
                         window.status = status + "\r\n" + xhr.responseText;
                         return false;
                     }
                 });
             }
             else {
                 $("#spnCity").text("Please Fill Mandatery Field");
                 $("#txtRevenueCentre").focus();
             }
         }
             function UpdateRevenueCentre() {
                 if ($.trim($("#txtRevenueCentre").val()) != "" && $.trim($("#txtDescription").val()) !="" && ( $("#<%=ddlRevenueName1.ClientID %>").val() !="0" )) {
                     var RevenueCentre = $("#txtRevenueCentre").val();
                     var Description = $("#txtDescription").val();
                     var OldName = $("#<%=ddlRevenueName1.ClientID %> option:selected").val();
                     var CostCentre = $("#<%=ddlCoseCentre1.ClientID%> option:selected").val();
                     if ($("#<%=rdbStatus.ClientID %> input[type=radio]:checked").val() == '1' )
                     {
                         Active="1";
                     }
                     else 
                         Active="0";
                     $.ajax({
                         url: "Demo_Tally_Interface_Master.aspx/RevenueUpdate",
                         data: '{RevenueCentre: "' + RevenueCentre + '",Description:"' + Description + '",Active:"' + Active + '",OldName:"' + OldName + '",CostCentreID:"' + CostCentre + '"}', // parameter map
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         timeout: 120000,
                         async: false,
                         dataType: "json",
                         success: function (result) {
                             Data = (result.d);
                             if (Data == "2") {
                                 $("#<%=lblMsg.ClientID%>").text('Record Update Successfully');
                             $("#txtRevenueCentre").val(' ');
                             $find('mpHeader').hide();
                             bindRevenueName();
                         }
                         else if (Data == "1") {
                             $("#<%=lblMsg.ClientID%>").text('Revenue Name Already Exist');
                            $("#txtRevenueCentre").val(' ');
                            $find('mpHeader').hide();
                            bindRevenueName();
                        }
                        else if (Data == "3") {
                            $("#<%=lblMsg.ClientID%>").text('Enter Revenue Name');
                            $("#txtRevenueCentre").val('');
                            $find('mpHeader').hide();
                            bindRevenueName();
                        }

                        else {
                            $("#<%=lblMsg.ClientID%>").text('Revenue Not Saved');
                            $find('mpHeader').hide();
                            bindRevenueName();
                        }

                     },
                     error: function (xhr, status) {
                         alert("Error ");
                         window.status = status + "\r\n" + xhr.responseText;
                         return false;
                     }
                         
                 });
    }
    else {
        $("#spnCity").text("Please Fill Mandatery Field");
        $("#txtRevenueCentre").focus();
    }
         }
         $(document).ready(function () {
             show();
             showCostCentre();
             bindCategory();
             bindActiveCostCentre();
             bindActiveCostCentreEdit();
             bindCostCentre();
         });
         function showCostCentre() {
             if ($("#<%=rdbCostNew.ClientID %> input[type=radio]:checked").val() == '0') {
                 $("#<%=ddlCostCentre.ClientID %>").hide();
                 $("#<%=txtCostDescription.ClientID %>").show();
                 $("#<%=rdbCostCentre.ClientID %>").hide();
                 $("#<%=lblCostStatus.ClientID %>").hide();
                 $('#Span2').show();
                 $("#<%=lblCostDesc.ClientID %>").show();
                 $('#btnSaveCostCentre').show();
                 $('#btnUpdateCostCentre').hide();
                 $('#<%=lblCostCentre.ClientID%>').hide();
             }
             if ($("#<%=rdbCostNew.ClientID %> input[type=radio]:checked").val() == '1') {
                 $("#<%=ddlCostCentre.ClientID %>").show();
                 $("#<%=lblRevenueName.ClientID %>").val('').show();
                 $("#<%=txtCostDescription.ClientID %>").val('').show();
                 $("#<%=lblCostStatus.ClientID %>").show();
                 $("#<%=rdbCostCentre.ClientID %>").show();
                 $('#Span2').show();
                 $("#<%=lblCostDesc.ClientID %>").show();
                 $('#btnSaveCostCentre').hide();
                 $('#btnUpdateCostCentre').show();
                 $('#<%=lblCostCentre.ClientID%>').show();
             }
         }
         function show()
         {
             if ($("#<%=rdbCheck.ClientID %> input[type=radio]:checked").val() == '0' ) {
                 $("#<%=ddlRevenueName1.ClientID %>").hide();
                 $("#<%=txtDescription.ClientID %>").show();
                 $("#<%=lblRevenueName.ClientID %>").hide();
                 $("#<%=rdbStatus.ClientID %>").hide();
                 $("#<%=lblStatus.ClientID %>").hide();
                 $('#spngg').show();
                 $("#<%=lblDescription.ClientID %>").show();
                 $('#btnSaveHeader').show();
                 $('#btnUpdate').hide();

             }
             if ($("#<%=rdbCheck.ClientID %> input[type=radio]:checked").val() == '1') {
                 $("#<%=ddlRevenueName1.ClientID %>").show();
                 $("#<%=lblRevenueName.ClientID %>").val('').show();
                 $("#<%=txtDescription.ClientID %>").val('').show();
                 $("#<%=rdbStatus.ClientID %>").show();
                 $("#<%=lblStatus.ClientID %>").show();
                 $('#spngg').show();
                 $("#<%=lblDescription.ClientID %>").show();
                 $('#btnSaveHeader').hide();
                 $('#btnUpdate').show();
             }
         }
         function bindRevenueName() {
             var ddlCoseCentre = $("#<%=ddlCoseCentre1.ClientID %>").val();
             var ddlRevenueName = $("#<%=ddlRevenueName1.ClientID %>");
             $("#<%=ddlRevenueName1.ClientID %>").empty();
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindRevenueName",
                 data: '{CoseCentre:"' + ddlCoseCentre + '"}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data != null) {
                         if (Data.length != 0) {
                             for (i = 0; i < Data.length; i++) {
                                 ddlRevenueName.append($("<option></option>").val(Data[i].RevenueID).html(Data[i].RevenueName));
                             }
                         }
                     }
                     else {
                         ddlRevenueName.append($("<option></option>").val("0").html("---No Record Found---"));
                     }
                    
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlRevenueName.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function bindActiveRevenue() {
             var ddlCoseCentre = $("#<%=ddlCoseCentre.ClientID %>").val();
             var ddlRevenueName = $("#<%=ddlRevenueCentre.ClientID %>");
             $("#<%=ddlRevenueCentre.ClientID %>").empty();
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindActiveRevenue",
                 data: '{CoseCentre:"' + ddlCoseCentre + '"}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data != null) {
                         if (Data.length != 0) {
                             for (i = 0; i < Data.length; i++) {
                                 ddlRevenueName.append($("<option></option>").val(Data[i].RevenueID).html(Data[i].RevenueName));
                             }
                         }
                     }
                     else {
                         ddlRevenueName.append($("<option></option>").val("0").html("---No Record Found---"));
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlRevenueName.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function bindCategory() {
             jQuery("#ddlCategory option").remove();
             var ddlCategory = $("#<%=ddlCategory.ClientID %>");
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindCategory",
                 data: '{}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data.length != 0) {
                         ddlCategory.append($("<option></option>").val("0").html("---Select---"));
                         for (i = 0; i < Data.length; i++) {
                             ddlCategory.append($("<option></option>").val(Data[i].CategoryID).html(Data[i].NAME));
                         }
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlRevenueName.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function bindSubCategory() {
             var ddlCategory = $("#<%=ddlCategory.ClientID %>").val();
             var ddlSubCategory = $("#<%=ddlSubCategory.ClientID %>");  
             $("#<%=ddlSubCategory.ClientID %>").empty();
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindSubCategory",
                 data: '{CategoryID:"' + ddlCategory + '"}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data != null) {
                         if (Data.length != 0) {
                             for (i = 0; i < Data.length; i++) {
                                 ddlSubCategory.append($("<option></option>").val(Data[i].SubCategoryID).html(Data[i].NAME));
                             }
                         }
                     }
                     else {
                         ddlSubCategory.append($("<option></option>").val(" ").html("---No Record Found---"));
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlSubCategory.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function bindActiveCostCentre() {
             jQuery("#ddlCoseCentre option").remove();
             var ddlCoseCentre = $("#<%=ddlCoseCentre.ClientID %>");
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindActiveCostCentre",
                 data: '{}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data.length != 0) {
                         ddlCoseCentre.append($("<option></option>").val("0").html("---Select---"));
                         for (i = 0; i < Data.length; i++) {
                             ddlCoseCentre.append($("<option></option>").val(Data[i].ID).html(Data[i].NAME));
                         }
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlCoseCentre.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function bindActiveCostCentreEdit() {
             jQuery("#ddlCoseCentre1 option").remove();
             var ddlCoseCentre1 = $("#<%=ddlCoseCentre1.ClientID %>");
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindActiveCostCentre",
                 data: '{}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data.length != 0) {
                         ddlCoseCentre1.append($("<option></option>").val("0").html("---Select---"));
                         for (i = 0; i < Data.length; i++) {
                             ddlCoseCentre1.append($("<option></option>").val(Data[i].ID).html(Data[i].NAME));
                         }
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlCoseCentre1.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function bindCostCentre() {
             var ddlCostCentre = $("#<%=ddlCostCentre.ClientID %>");
             jQuery.ajax({
                 url: "Demo_Tally_Interface_Master.aspx/bindCostCentre",
                 data: '{}', // parameter map
                 type: "POST",
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     Data = jQuery.parseJSON(result.d);
                     if (Data.length != 0) {
                         ddlCostCentre.append($("<option></option>").val("0").html("---Select---"));
                         for (i = 0; i < Data.length; i++) {
                             ddlCostCentre.append($("<option></option>").val(Data[i].ID).html(Data[i].NAME));
                         }
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     ddlCostCentre.attr("disabled", false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
        // function SaceCostCentre()
         // {
         //  if ($.trim($("#txtCostName").val()) != "" && $.trim($("#txtCostDescription").val()) != "" ) {
         //  var RevenueCentre = $("#txtCostName").val();
         //  var Description = $("#txtCostDescription").val();
             
         //  $.ajax({
         //    url: "Demo_Tally_Interface_Master.aspx/CostCentreInsert",
         //   data: '{RevenueCentre: "' + RevenueCentre + '",Description:"' + Description + '"}', // parameter map
         //    type: "POST",
         //    contentType: "application/json; charset=utf-8",
         //    timeout: 120000,
         //     async: false,
         //  dataType: "json",
         //   success: function (result) {
         //       Data = (result.d);
         //      if (Data == "2") {
         //          $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
         //         $("#txtCostName").val(' ');
         //          $find('mpdCostCentre').hide();
         //      }
         //     else if (Data == "1") {
         //        $("#<%=lblMsg.ClientID%>").text('Cost Centre Name Already Exist');
         //        $("#txtCostName").val(' ');
         //        $find('mpdCostCentre').hide();
         //    }
         //    else if (Data == "3") {
         //               $("#<%=lblMsg.ClientID%>").text('Enter Cost Centre Name');
         //                $("#txtCostName").val('');
         //                 $find('mpdCostCentre').hide();
         //             }
         //
         //             else {
         //                 $("#<%=lblMsg.ClientID%>").text('Cost Centre Not Saved');
         //                 $find('mpdCostCentre').hide();
         //             }
         //              bindActiveCostCentre();
         //             bindActiveCostCentreEdit();
         //         },
         //         error: function (xhr, status) {
         //              alert("Error ");
         //              window.status = status + "\r\n" + xhr.responseText;
         //               return false;
         //          }
         //      });
         //  }
         //  else {
         //    $("#spnCostError").text("Please Fill Mandatery Field");
         //   $("#txtRevenueCentre").focus();
         //  }
         //  } 
         function UpdateCostCentre() {
             if ($.trim($("#txtCostName").val()) != "" && $.trim($("#txtCostDescription").val()) != "" && ($("#<%=ddlCostCentre.ClientID %>").val() != "0")) {
                 var RevenueCentre = $("#txtCostName").val();
                 var Description = $("#txtCostDescription").val();
                     var CostCentre = $("#<%=ddlCostCentre.ClientID%> option:selected").val();
                     if ($("#<%=rdbCostCentre.ClientID %> input[type=radio]:checked").val() == '1') {
                         Active = "1";
                     }
                     else
                         Active = "0";
                     $.ajax({
                         url: "Demo_Tally_Interface_Master.aspx/CostCentrerUpdate",
                         data: '{RevenueCentre: "' + RevenueCentre + '",Description:"' + Description + '",Active:"' + Active + '",CostCentreID:"' + CostCentre + '"}', // parameter map
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         timeout: 120000,
                         async: false,
                         dataType: "json",
                         success: function (result) {
                             Data = (result.d);
                             if (Data == "2") {
                                 $("#<%=lblMsg.ClientID%>").text('Record Update Successfully');
                                 $find('mpdCostCentre').hide();
                                 bindActiveCostCentre();
                                 clear();
                             }
                             else if (Data == "1") {
                                 $("#<%=lblMsg.ClientID%>").text('Cost Centre Name Already Exist');
                             $find('mpdCostCentre').hide();
                             bindActiveCostCentre();
                             clear();
                         }
                         else if (Data == "3") {
                             $("#<%=lblMsg.ClientID%>").text('Enter Cost Centre Name');
                            $find('mpdCostCentre').hide();
                            bindActiveCostCentre();
                            clear();
                        }

                        else {
                             $("#<%=lblMsg.ClientID%>").text('Cost Centre Not Saved');
                             $find('mpdCostCentre').hide();
                             bindActiveCostCentre();
                             clear();
                        }

                         },
                         error: function (xhr, status) {
                             alert("Error ");
                             window.status = status + "\r\n" + xhr.responseText;
                             return false;
                         }

                     });
    }
    else {
                 $("#spnCostError").text("Please Fill Mandatery Field");
        $("#txtCostName").focus();
    }
         }
         function clear()
         {
             $("#<%=ddlCostCentre.ClientID%>").val(0);
             $("#txtCostName").val('');
             $('#txtCostDescription').val('');
             $("<%=rdbCostNew.ClientID%> input[type=radio][value=" + 0 + "]").prop('checked', true);
            // $("#<%=rdbCostCentre.ClientID%> ").removeAttr('checked');
         }
         function MapItemsFrom_ERTo_OtherWard() {
             if ($('#chkMapWard').attr('checked')) {
                 $.ajax({
                     url: "Demo_Tally_Interface_Master.aspx/SaveWardItems",
                     data: '{}', // parameter map
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         Data = (result.d);
                         if (Data == "1") {
                             $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
                             alert("Record Saved Successfully");
                         }
                     },
                      error: function (xhr, status) {
                          alert("Error ");
                          window.status = status + "\r\n" + xhr.responseText;
                          alert("Record Not Saved");
                          return false;
                      }
                  });
             }
             else
                 alert("Please select Check box");
         }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <ajax:scriptmanager ID="ScriptManager" runat="Server" />
            <b> Revenue Mapping Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr>
                    <td align="right" style=" width: 174px;">Cost Centre:</td>
                    <td style="width: 566px;">
                      <asp:DropDownList ID="ddlCoseCentre" runat="server" ClientIDMode="Static" Width="250px" onchange="bindActiveRevenue(),BindMaping()"> </asp:DropDownList>
                         <asp:Button ID="btnNewCostCentre" runat="server" CssClass="ItDoseButton" style="display:none"
                            Text="New CostCentre" ToolTip="Click To Add New Header" />
                       
    <asp:Panel ID="pnlCostCentre" runat="server" CssClass="pnlItemsFilter" style="display:none"
        Width="420px">
        <div class="Purchaseheader">
                Create Cost Centre&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;
            </div>
      
            <table style="width: 100%">
                <tr>
                    <td colspan="2" style="text-align:center">
                        <span id="spnCostError" class="ItDoseLblError"></span>
                    </td>
                </tr>
                <tr>
                    <td><asp:RadioButtonList ID="rdbCostNew" runat="server"  onclick="showCostCentre();" RepeatDirection="Horizontal" ClientIDMode="Static">
                        <asp:ListItem Value="0" Selected="True">New</asp:ListItem>
                        <asp:ListItem Value="1">Edit</asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                
                <tr>
                    <td style="width: 30%; text-align: right"><asp:Label ID="lblCostCentre" runat="server" Text="CostCentre Name :"></asp:Label>&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left">
                      <asp:DropDownList ID="ddlCostCentre" runat="server" Width="250" ClientIDMode="Static"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right">Name :&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left">
                        <input type="text" id="txtCostName"  title="Enter Name" tabindex="1"  />
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                </tr>
                 <tr>
                    <td align="right" valign="top" style="width: 30%"><asp:Label ID="lblCostDesc" runat="server" Text="Description :"></asp:Label>&nbsp;
                    </td>
                    <td style="width: 70%">
                        <asp:TextBox ID="txtCostDescription" ClientIDMode="Static" runat="server" Width="240px" TabIndex="2"
                            TextMode="MultiLine"></asp:TextBox>
                         <span style="color: red; font-size: 10px;" id="Span2">*</span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right"><asp:Label ID="lblCostStatus" runat="server" Text="Status"></asp:Label></td>
                    <td><asp:RadioButtonList ID="rdbCostCentre" runat="server"  RepeatDirection="Horizontal">
                        <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                        <asp:ListItem Value="0">Deactive</asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td colspan="2" style="width: 100%; text-align: center">
                        <input type="button" onclick="SaceCostCentre();" tabindex="3" value="Save" class="ItDoseButton" id="btnSaveCostCentre" style="display:none" title="Click To Save" />
                        <input type="button" onclick="UpdateCostCentre();" tabindex="3" value="Update" class="ItDoseButton" id="btnUpdateCostCentre" title="Click To Update" />
                        &nbsp;<input type="button" onclick="clear();" value="Cancel" id="Button4" class="ItDoseButton"/><%--<asp:Button ID="Button4" runat="server" TabIndex="26" ClientIDMode="Static"
                            CssClass="ItDoseButton" Text="Cancel"  onclick="clear();"/>--%></td>
                </tr>
            </table>
       
    </asp:Panel>
                    </td>
                    <td style="width: 155px; text-align:right">Category :&nbsp;
                    </td>
                    <td >
                        <asp:DropDownList ID="ddlCategory" onchange="bindSubCategory(),BindNonMapItem();" runat="server" Width="300px" />
                        
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 174px">Revenue Name:</td>
                    <td style="width: 566px">
                         <asp:DropDownList ID="ddlRevenueCentre" runat="server" Width="250px" onchange="BindMaping();"
                                 TabIndex="5">
                            </asp:DropDownList>
                       
                        <asp:Button ID="btnNewHeader" runat="server" CssClass="ItDoseButton" style="display:none"
                            Text="New Revenue" ToolTip="Click To Add New Header" />
                        <cc1:modalpopupextender ID="mpHeader" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlHeader" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnNewHeader" BehaviorID="mpHeader">
    </cc1:modalpopupextender>
    <asp:Panel ID="pnlHeader" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="420px">
        <div class="Purchaseheader">
                Create Revenue&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;
            </div>
      
            <table style="width: 100%">
                <tr>
                    <td colspan="2" style="text-align:center">
                        <span id="spnCity" class="ItDoseLblError"></span>
                    </td>
                </tr>
                <tr>
                    <td><asp:RadioButtonList ID="rdbCheck" runat="server"  onclick="show();" RepeatDirection="Horizontal">
                        <asp:ListItem Value="0" Selected="True">New</asp:ListItem>
                        <asp:ListItem Value="1">Edit</asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right"><asp:Label ID="Label1" runat="server" Text="Cost Centre :"></asp:Label>&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left">
                      <asp:DropDownList ID="ddlCoseCentre1" runat="server" Width="250" ClientIDMode="Static" onchange="bindRevenueName();"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right"><asp:Label ID="lblRevenueName" runat="server" Text="Revenue Name :"></asp:Label>&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left">
                      <asp:DropDownList ID="ddlRevenueName1" runat="server" Width="250"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right">Name :&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left">
                        <input type="text" id="txtRevenueCentre"  title="Enter Header" tabindex="1"  />
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                </tr>
                 <tr>
                    <td align="right" valign="top" style="width: 30%"><asp:Label ID="lblDescription" runat="server" Text="Description :"></asp:Label>&nbsp;
                    </td>
                    <td style="width: 70%">
                        <asp:TextBox ID="txtDescription" ClientIDMode="Static" runat="server" Width="240px" TabIndex="2"
                            TextMode="MultiLine"></asp:TextBox>
                         <span style="color: red; font-size: 10px;" id="spngg">*</span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right"><asp:Label ID="lblStatus" runat="server" Text="Status"></asp:Label></td>
                    <td><asp:RadioButtonList ID="rdbStatus" runat="server"  RepeatDirection="Horizontal">
                        <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                        <asp:ListItem Value="0">Deactive</asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td colspan="2" style="width: 100%; text-align: center">
                        <input type="button" onclick="SaveRevenueCentre();" tabindex="3" value="Save" class="ItDoseButton" id="btnSaveHeader" title="Click To Save" />
                        <input type="button" onclick="UpdateRevenueCentre();" tabindex="3" value="Update" class="ItDoseButton" id="btnUpdate" title="Click To Update" />
                        &nbsp;<asp:Button ID="btnRCancel" runat="server" TabIndex="26"
                            CssClass="ItDoseButton" Text="Cancel" />
                    </td>
                </tr>
            </table>
       
    </asp:Panel>
                    </td>
                    <td style="width: 155px; text-align:right">SubCategory :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlSubCategory" onchange="BindNonMapItem();" runat="server" Width="300px" />
                    </td>
                </tr>


            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Mapping Detail
            </div>
            <table width="100%">
                <tr>
                    <td>
 
                    </td>
                    <td>Available
                    </td>
                    <td></td>
                    <td>Remaining
                    </td>
                </tr>
                <tr>
                    <td>
                        
                       <img  id="right" src="../../Images/Down.png" alt="" title="Click To Remove Mapping" />
                        <br />
                        &nbsp;</td>
                    <td>
                        <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="400px" SelectionMode="Multiple"
                            CssClass="ItDoseListbox" Width="425px"></asp:ListBox>
                    </td>
                    <td>
                        <img  id="left" src="../../Images/Left.png" alt=""  title="Click To Map The Item"/>
                       <%-- <input type="button" id="left" value="<<" class="ItDoseButton" />--%>


                        <br />
                        <br />
                      <%--   <img  id="right" src="../../Images/Right.png" alt="" />--%>
                       <%-- <input type="button" id="right" value=">>" class="ItDoseButton" />--%>
                    </td>
                    <td>
                        <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" Height="400px"
                            Width="425px" CssClass="ItDoseListbox"></asp:ListBox>
                    </td>
                </tr>
            </table>
            <div style="display:none">
                <input type="checkbox" id="chkMapWard" /><span style="background-color:lightcoral" > Copy the Emergency Revenues to others wards</span>
                <input type="button" id="btnMapWard" class="ItDoseButton" value="Map Ward" onclick="MapItemsFrom_ERTo_OtherWard()" />
            </div>
        </div>

    </div>
     <cc1:modalpopupextender ID="mpdCostCentre" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="Button4" DropShadow="true" PopupControlID="pnlCostCentre" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnNewCostCentre" BehaviorID="mpdCostCentre" >
    </cc1:modalpopupextender>
</asp:Content>
